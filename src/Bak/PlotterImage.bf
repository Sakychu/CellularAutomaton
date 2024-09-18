using BasicEngine;
using System.Diagnostics;
using SDL2;
using BasicEngine.Debug;
using System;
using System.Collections;
using System.Threading;
using System.Threading.Tasks;

namespace Plotter.Entity
{
	class PlotterImage
	{
		Vector2D mChunkPos = null ~ SafeDelete!(_);

		private uint32 mDrawCycle = 0;

		private double yMin = -2.0;// Default minimum Y for the set to render.
		private double yMax = 0.0;// Default maximum Y for the set to render.
		private double xMin = -2.0;// Default minimum X for the set to render.
		private double xMax = 1.0;// Default maximum X for the set to render.

		public double xOffset = 0;// Default maximum X for the set to render.
		public double yOffset = 0.0;// Default maximum Y for the set to render.

		private int32 kMax = 50;

		private int32 xyPixelStep = 4;
		private float zoomScale = 1;// Default amount to zoom in by.

		private Image mCurrentImage ~ SafeDelete!(_);
		private List<Image> lImages = new List<Image>() ~ DeleteContainerAndItems!(_);
		private Size2D mSize ~ SafeDelete!(_);

		private bool savingImage = false;
		public List<Thread> mRenderThreads = new List<Thread>() ~ DeleteContainerAndItems!(_);
		volatile public bool[] mThreadEnabled = null ~ SafeDelete!(_);

		private int64[] lastRenderingTime = new int64[16]() ~ SafeDelete!(_);
		public int64[] LastRenderingTimes { get { return Volatile.Read<int64[]>(ref lastRenderingTime); } }

		public bool RenderingDone
		{
			get
			{
				for (var t in mRenderThreads)
				{
					if (t.IsAlive == true)
						return false;
				}
				return true;
			}
		}

		public this(Size2D size, int32 kMaximum = 200, int zoomS = 1)
		{
			mSize = size;
			yMin = 0;
			yMax = 0;
			xMin = 0;
			xMax = 0;
			xyPixelStep = 1;
			zoomScale = zoomS;

			mRenderThreads.Add(new Thread(new () => RenderImageOne()));
			/*mRenderThreads.Add(new Thread(new () => RenderImageTwo()));
			mRenderThreads.Add(new Thread(new () => RenderImageThree()));
			mRenderThreads.Add(new Thread(new () => RenderImageFour()));
			mRenderThreads.Add(new Thread(new () => RenderImage5()));*/

			mThreadEnabled = new bool[8];
			mThreadEnabled[0] = true;
		}

		public this(Vector2D chunkPos, Size2D size, int pixelStep = 1, int zoomS = 1)
		{
			mChunkPos = chunkPos;
			yMin = chunkPos.mY;
			yMax = (chunkPos.mY + pixelStep);
			xMin = chunkPos.mX;
			xMax = (chunkPos.mX + pixelStep);
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
			gEngineApp.Draw(drawImage, projectedPos.mX, projectedPos.mY, 0f, gGameApp.mCam.mScale);//mPos.mX, mPos.mY, mDrawAngle);
		}

		public void PreperRenderImages()
		{
			List<bool> lbool = scope List<bool>();

			for (var i in ..<mThreadEnabled.Count)
			{
				lbool.Add(mThreadEnabled[i]);
				mThreadEnabled[i] = false;
			}
			while (!RenderingDone)
			{
				SDL.Delay(10);
			}
			for (var i in ..<lbool.Count)
			{
				mThreadEnabled[i] = lbool[i];
			}
			SDL.Delay(200);
			/*var images = Volatile.Read<List<Image>>(ref lImages);
			//Volatile.Write<List<Image>>(ref lImages, new List<Image>());

			for (var i in ..<images.Count)
			{
				//SafeDelete!(Volatile.Read<Image>(ref images[i]));
			}*/
			//images.Clear();

			for (var i in ..<mRenderThreads.Count)
			{
				if (mThreadEnabled[i])
				{
					RenderImageTwo();
				}
			}
			{
				/*for (var i in ..<mRenderThreads.Count)
				{
					DeleteAndNullify!(mRenderThreads[i]);
				}
				mRenderThreads.Clear();

				mRenderThreads.Add(new Thread(new () => RenderImageOne()));
				mRenderThreads.Add(new Thread(new () => RenderImageThree()));
				mRenderThreads.Add(new Thread(new () => RenderImage5()));*/
			}
		}

		public void RenderImageByPixel(int32 pixelStep)
		{
			var ret = GetRenderImage(yMin / zoomScale + yOffset,
				(yMax) / zoomScale + yOffset,
				(xMin) / zoomScale + xOffset,
				(xMax) / zoomScale + xOffset,
				(int32)(kMax + (zoomScale / 10))
				, pixelStep);
			switch (ret)
			{
			case .Err(let err):
				Logger.Error("");
				return;
			case .Ok(let retImage):
				int cnt = 0;
				while (savingImage)
				{
					SDL.Delay(1);
					if (++cnt > 200)
					{
						break;
					}
				}
				savingImage = true;
				var img = Volatile.Read<Image>(ref mCurrentImage);
				var imgList = Volatile.Read<List<Image>>(ref lImages);
				imgList.Add(img);
				Volatile.Write<Image>(ref mCurrentImage, retImage);
				savingImage = false;
			}
		}

		public void RenderImageOne()
		{
			RenderImageByPixel(1);
		}
		public void RenderImageTwo()
		{
			RenderImageByPixel(2);
		}
		public void RenderImageThree()
		{
			RenderImageByPixel(3);
		}
		public void RenderImageFour()
		{
			RenderImageByPixel(4);
		}

		public void RenderImage5()
		{
			RenderImageByPixel(5);
		}

		public void RenderImage6()
		{
			RenderImageByPixel(6);
		}

		public void RenderImage()
		{
			var ret = GetRenderImage(yMin / zoomScale + yOffset, (yMax) / zoomScale + yOffset, (xMin) / zoomScale + xOffset, (xMax) / zoomScale + xOffset, (int32)(kMax + zoomScale), xyPixelStep);

			Image img = Volatile.Read<Image>(ref mCurrentImage);
			if (img != null)
				delete img;
			Volatile.Write<Image>(ref mCurrentImage, ret);
			lImages.Add(ret);
			//SafeMemberSet!(mImage, ret);
		}

		public Result<SDL2.Image> GetRenderImage(double yMin, double yMax, double xMin, double xMax, int32 kMax, int32 pixelStep)
		{
			Volatile.Write<int64>(ref lastRenderingTime[pixelStep], 0);

			SDL2.Image image = new Image();
			DrawUtils.CreateTexture(image, mSize, gEngineApp.mRenderer, .Streaming);

			var err = SDL.LockTexture(image.mTexture, null, var data, var pitch);
			if (err != 0)
			{
				Logger.Debug(scope String(SDL.GetError()));
				logCurrentTime(-1, pixelStep);
				SDL.UnlockTexture(image.mTexture);
				SDLError!(err);
				return .Err((void)"Thread terminated");
			}

			SDL2.SDL.Color color;

			v2d<double> screenBottomLeft = v2d<double>(xMin, yMin);
			v2d<double> screenTopRight = v2d<double>(xMax, yMax);

			var myPixelManager = scope ScreenPixelManage(gGameApp.mRenderer, screenBottomLeft, screenTopRight);

			v2d<double> xyStep = myPixelManager.GetDeltaMathsCoord(v2d<double>(pixelStep, pixelStep));

			Stopwatch sw = scope Stopwatch();
			sw.Start();

			int yPix = (int)mSize.Height - 1;
			for (double y = yMin; y < yMax; y += xyStep.y)
			{
				int xPix = 0;
				for (double x = xMin; x < xMax; x += xyStep.x)
				{
					if (!mThreadEnabled[pixelStep - 1])
					{
						logCurrentTime(-1, pixelStep);
						SDL.UnlockTexture(image.mTexture);
						delete image;
						return .Err((void)"Thread terminated");
					}

					double cx = x;
					double cy = y;

					/*v2d<double> zk = .();

					zk.x += 1.771;
					zk.y += 1.255;*/

					//var index = (int)(zk.x + zk.y);
					var max = 1;
					//var index = 1 / Math.Abs(cx * cy);
					var index = (cx + (xMax * cy)) / (xMax * yMax);

					//color = IndexToColor(index, (int)(xMax * yMax) * 100);
					//color = ColourTable.ColorFromHSLA(index, 0.9, 0.6);
					color = ColourTable.ColorFromHSLA(gRand.RandomGaussian(), 0.9 * gRand.RandomGaussian(), 0.6 * gRand.RandomGaussian());
					//color = SDL.Color((uint8)(cx / xMax * 0xFF), (uint8)(cy / yMax * 0xFF) & 0xFF, (uint8)(index * 0xFF), (uint8)(gRand.NextDouble() * 0xFF));

					//colorLast = color;
					if (index <= 1)
					{
						if (pixelStep == 1)
						{
							if ((xPix < image.mSurface.w) && (yPix >= 0))
							{
								SetPixel((uint32*)data, image, xPix, yPix, color);
							}
						} else
						{
							SetPixels((uint32*)data, image, xPix, yPix, pixelStep, pixelStep, color);
						}
					}
					xPix += pixelStep;
				}
				yPix -= pixelStep;

				if (sw.ElapsedMicroseconds - getCurrentTime(pixelStep) >= 1000000)
				{
					logCurrentTime(sw.ElapsedMicroseconds, pixelStep);
				}
			}

			sw.Stop();
			logCurrentTime(sw.ElapsedMicroseconds, pixelStep);

			SDL.UnlockTexture(image.mTexture);
			return .Ok(image);
		}

		void logCurrentTime(int64 renderingTime, int pixelStep)
		{
			Volatile.Write<int64>(ref lastRenderingTime[pixelStep], renderingTime);
			Logger.Debug(StackStringFormat!("{} : {}", pixelStep, TimeSpan(renderingTime)));
		}

		int64 getCurrentTime(int pixelStep)
		{
			return Volatile.Read<int64>(ref lastRenderingTime[pixelStep]);
		}

		[Inline]
		void SetPixels(uint32* data, Image image, int x, int y, int w, int h, SDL.Color color)
		{
			SDL.PixelFormat* fmt = image.mSurface.format;
			var color8888 = ((uint32)color.r << fmt.rshift | (uint32)color.g << fmt.gshift | (uint32)color.b << fmt.bshift) | (uint32)color.a;
			for (int iy = y; iy > y - w; iy--)
			{
				var indexY = (image.mSurface.w) * iy;
				for (int ix = x; ix < x + w; ix++)
				{
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
			uint32 temp = *(uint8*)pixel_ptr & fmt.Rmask;/* Isolate red component */
			temp = temp >> fmt.rshift;/* Shift it down to 8-bit */
			temp = temp << fmt.rloss;/* Expand to a full 8-bit number */
			uint8 red = (uint8)temp;

			/* Get Green component */
			temp = *(uint8*)pixel_ptr & fmt.Gmask;/* Isolate green component */
			temp = temp >> fmt.gshift;/* Shift it down to 8-bit */
			temp = temp << fmt.gloss;/* Expand to a full 8-bit number */
			uint8 green = (uint8)temp;

			/* Get Blue component */
			temp = *(uint8*)pixel_ptr & fmt.Bmask;/* Isolate blue component */
			temp = temp >> fmt.bshift;/* Shift it down to 8-bit */
			temp = temp << fmt.bloss;/* Expand to a full 8-bit number */
			uint8 blue = (uint8)temp;

			/* Get Alpha component */
			temp = *(uint8*)pixel_ptr & fmt.Amask;/* Isolate alpha component */
			temp = temp >> fmt.Ashift;/* Shift it down to 8-bit */
			temp = temp << fmt.Aloss;/* Expand to a full 8-bit number */
			uint8 alpha = (uint8)temp;

			return .(red, green, blue, alpha);
		}
	}
}
