using BasicEngine;
using System.Collections;
using BasicEngine.Collections;
using System.Diagnostics;
using System;

namespace CelluarAutomaton.Entity
{
	class CelluarAutomaton : RawPixelDrawable
	{
		public enum Cell : uint8
		{
			None,
			Tree,
			Fire
		}

		public SDL2.SDL.Color GetColor(Cell c)
		{
			SDL2.SDL.Color ret = .();

			switch (c) {
			case .None:
				ret = .(127, 127, 78, 255);
				break;
			case .Fire:
				ret = .(255, 0, 0, 255);
				break;
			case .Tree:
				ret = .(0, 255, 0, 255);
				break;
			}
			return ret;
		}

	  //public List<Cell> lCells = new List<Cell>() ~ DeleteContainerAndItems!(_);

	  //private List<Cell> toDelete = null;
		public Cell[,] cellGrid = null ~ SafeDelete!(_);

		public this(Size2D size) : base(size)
		{
			cellGrid = new Cell[1024, 1024];
		}

		public Cell GetCellAt(v2d<int> pos)
		{
			Cell ret = cellGrid[pos.y, pos.x];

			return ret;
		}

		public Cell GetCellAt(int x, int y)
		{
			return cellGrid[y, x];
		}

		[Inline]
		public void SetCellAt(Cell c, v2d<int> pos)
		{
			cellGrid[pos.y, pos.x] = c;
		}

		public void Update()
		{
			Stopwatch sw = scope Stopwatch();
			sw.Start();

			Dictionary<v2d<int>, Cell> updates = scope Dictionary<v2d<int>, Cell>();

			for (var i in 0 ..< 1)
			{
				if (gGameApp.mRand.Next(0, 100) >= 75)
				{
					SetCellAt(.Tree, .(gGameApp.mRand.Next(0, gGameApp.mScreen.w), gGameApp.mRand.Next(0, gGameApp.mScreen.h)));
				}
			}

			for (var update in updates)
			{
				SetCellAt(update.value, update.key);
			}

			sw.Stop();
			logCurrentTime(sw.ElapsedMicroseconds);
		}

		public override void RenderLoop(int32 pixelStep, SDL2.Image image, uint32* data)
		{
			//base.RenderLoop(pixelStep, image, data);
			var halfPixelStep = pixelStep / 2;
			for (var x = 0; x < [Friend]mSize.mX; x++)
			{
				for (var y = 0; y < [Friend]mSize.mX; y++)
				{
					var cell = GetCellAt(x, y);
					if(cell == .None)
						continue;
					var xPos = x - halfPixelStep;
					var yPos = y - halfPixelStep;
					if (xPos < 0 || yPos < 0 || xPos > [Friend]mSize.mX || yPos > [Friend]mSize.mY)
						continue;
					SetCell(xPos, yPos, pixelStep, image, data, GetColor(cell));
				}
			}
		}
	}
}
