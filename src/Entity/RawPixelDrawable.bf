using BasicEngine;
using System.Diagnostics;
using SDL2;
using BasicEngine.Debug;
using System;
using System.Collections;
using System.Threading;
using System.Threading.Tasks;

namespace CelluarAutomaton.Entity
{
	class RawPixelDrawable
	{
		Vector2D mChunkPos = null ~ SafeDelete!(_);

		private uint32 mDrawCycle = 0;

		private int32 xyPixelStep = 1;
		private bool mPreventNextRender = false;
		private float zoomScale = 1; // Default amount to zoom in by.

		private Image mCurrentImage ~ SafeDelete!(_);
		protected Size2D mSize ~ SafeDelete!(_);

		private int64 lastRenderingTime = 0;
		public int64 LastRenderingTimes { get { return lastRenderingTime; } }

		public this(Size2D size, int zoomS = 1)
		{
			mSize = size;
			zoomScale = zoomS;
		}

		public this(Vector2D chunkPos, Size2D size, int pixelStep = 1, int zoomS = 1)
		{
			mChunkPos = chunkPos;
			zoomScale = zoomS;
			xyPixelStep = (int32)pixelStep;
			mSize = size;
		}

		public void Draw()
		{
			Vector2D projectedPos = gGameApp.mCam.GetProjected(scope Vector2D(0, mSize.Height / 1000));
			defer delete projectedPos;

			Image drawImage = Volatile.Read<Image>(ref mCurrentImage);

			if (drawImage?.mTexture == null)
				return;
			gEngineApp.Draw(drawImage, projectedPos.mX, projectedPos.mY, 0f, gGameApp.mCam.mScale); //mPos.mX, mPos.mY, mDrawAngle);
		}

		public void RenderImageByPixel(int32 pixelStep)
		{
			var ret = GetRenderImage(pixelStep);
			switch (ret)
			{
			case .Err(let err):
				Logger.Error("");
				return;
			case .Ok(let retImage):
				SafeMemberSet!(mCurrentImage, retImage);
			}
		}

		public void RenderImage()
		{
			if (mPreventNextRender)
			{
				mPreventNextRender = false;
				return;
			}
			var ret = GetRenderImage(xyPixelStep);
			mDrawCycle++;
			switch (ret)
			{
			case .Err(let err):
				Logger.Error("");
				return;
			case .Ok(let retImage):
				SafeMemberSet!(mCurrentImage, retImage);
			}
		}

		public virtual Result<SDL2.Image> GetRenderImage(int32 pixelStep)
		{
//			lastRenderingTime = 0;

			SDL2.Image image = new Image();
			DrawUtils.CreateTexture(image, mSize, gEngineApp.mRenderer, .Streaming);
			var err = SDL.LockTexture(image.mTexture, null, var data, var pitch);
			if (err != 0)
			{
				Logger.Debug(scope String(SDL.GetError()));
				logCurrentTime(-1);
				SDL.UnlockTexture(image.mTexture);
				SDLError!(err);
				return .Err((void)"Thread terminated");
			}

			RenderLoop(pixelStep, image, (uint32*)data);

			SDL.UnlockTexture(image.mTexture);
			return .Ok(image);
		}

		public virtual void RenderLoop(int32 pixelStep, SDL2.Image image, uint32* data)
		{
			SDL2.SDL.Color color;

			Stopwatch sw = scope Stopwatch();
			sw.Start();

			for (int y = (int)mSize.Height - 1; y >= 0; y -= pixelStep)
			{
				for (int x = 0; x < (int)mSize.Width; x += pixelStep)
				{
					color = CalculatePixel(x, y, mDrawCycle);

					SetCell(x, y, pixelStep, image, data, color);
				}
			}

			sw.Stop();
			logCurrentTime(sw.ElapsedMicroseconds);

			/*if (sw.ElapsedMicroseconds - getCurrentTime(pixelStep) >= 1000000)
			{
				logCurrentTime(sw.ElapsedMicroseconds, pixelStep);
			}*/
		}

		public virtual SDL2.SDL.Color CalculatePixel(int x, int y, int drawCycle)
		{
			//SDL2.SDL.Color c = ColourTable.ColorFromHSLA(gRand.RandomGaussian(), 0.9 * gRand.RandomGaussian(), 0.6 * gRand.RandomGaussian());
			SDL2.SDL.Color c =  SDL.Color((uint8)x, (uint8)y, (uint8)((x & 255) + (y & 255)), 255);
			//SDL2.SDL.Color c =  SDL.Color((uint8)mDrawCycle, (uint8)mDrawCycle, (uint8)mDrawCycle, 255);
			return c;
		}

		protected void logCurrentTime(int64 renderingTime)
		{
			lastRenderingTime = renderingTime;
			//Logger.Debug(StackStringFormat!("{} : {}", pixelStep, TimeSpan(renderingTime)));
		}

		int64 getCurrentTime(int pixelStep)
		{
			return lastRenderingTime;
		}


		[Inline]
		protected void SetCell(int x, int y, int32 pixelStep, SDL2.Image image, uint32* data, SDL2.SDL.Color color)
		{
			if (pixelStep == 1)
			{
				if ((x < image.mSurface.w) && (y >= 0))
				{
					SetPixel((uint32*)data, image, x, y, color);
				}
			} else
			{
				SetPixels((uint32*)data, image, x, y, pixelStep, pixelStep, color);
			}
		}

		[Inline]
		void SetPixels(uint32* data, Image image, int x, int y, int w, int h, SDL.Color color)
		{
			SDL.PixelFormat* fmt = image.mSurface.format;
			var color8888 = ((uint32)color.r << fmt.rshift | (uint32)color.g << fmt.gshift | (uint32)color.b << fmt.bshift) | (uint32)color.a;
			for (int iy = y; iy > y - h; iy--)
			{
				if (iy < 0 || iy > image.mSurface.h)
					continue;
				var indexY = (image.mSurface.w) * iy;
				for (int ix = x; ix < x + w; ix++)
				{
					if (ix < 0 || ix > image.mSurface.w - 1)
						continue;
					(data)[indexY + ix] = color8888;
				}
			}
		}

		[Inline]
		void SetPixel(uint32* data, Image image, int x, int y, SDL.Color color)
		{
			SDL.PixelFormat* fmt = image.mSurface.format;
			(data)[(image.mSurface.w) * y + x] = ((uint32)color.r << fmt.rshift | (uint32)color.g << fmt.gshift | (uint32)color.b << fmt.bshift) | (uint32)color.a;
		}

		static public SDL.Color IndexToColor(double i, int max)
		{
			double colourIndex = (i) / max;
			double hue = Math.Pow(colourIndex, 0.25);

			return ColourTable.ColorFromHSLA(hue, 0.9, 0.6);
		}

		SDL.Color GetPixel(int x, int y)
		{
			SDL.PixelFormat* fmt = mCurrentImage.mSurface.format;
			uint8 bytes_per_pixel = fmt.bytesPerPixel;

			var pixel = mCurrentImage.mSurface.pixels;

			uint32* pixel_ptr = (uint32*)pixel + y * mCurrentImage.mSurface.pitch + x * bytes_per_pixel;

			/* Get Red component */
			uint32 temp = *(uint8*)pixel_ptr & fmt.Rmask; /* Isolate red component */
			temp = temp >> fmt.rshift; /* Shift it down to 8-bit */
			temp = temp << fmt.rloss; /* Expand to a full 8-bit number */
			uint8 red = (uint8)temp;

			/* Get Green component */
			temp = *(uint8*)pixel_ptr & fmt.Gmask; /* Isolate green component */
			temp = temp >> fmt.gshift; /* Shift it down to 8-bit */
			temp = temp << fmt.gloss; /* Expand to a full 8-bit number */
			uint8 green = (uint8)temp;

			/* Get Blue component */
			temp = *(uint8*)pixel_ptr & fmt.Bmask; /* Isolate blue component */
			temp = temp >> fmt.bshift; /* Shift it down to 8-bit */
			temp = temp << fmt.bloss; /* Expand to a full 8-bit number */
			uint8 blue = (uint8)temp;

			/* Get Alpha component */
			temp = *(uint8*)pixel_ptr & fmt.Amask; /* Isolate alpha component */
			temp = temp >> fmt.Ashift; /* Shift it down to 8-bit */
			temp = temp << fmt.Aloss; /* Expand to a full 8-bit number */
			uint8 alpha = (uint8)temp;

			return .(red, green, blue, alpha);
		}

		public void PreventNextRender()
		{
			mPreventNextRender = true;
		}
	}
}
