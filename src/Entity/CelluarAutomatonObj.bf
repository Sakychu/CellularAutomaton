using BasicEngine;
using System.Collections;
using CelluarAutomaton.Entity.Cell;
using CelluarAutomaton.Entity.Cell.Brains;
using BasicEngine.Collections;
using System;
using System.Diagnostics;

namespace CelluarAutomaton.Entity
{
	class CelluarAutomatonObj : RawPixelDrawable
	{
		//public List<Cell> lCells = new List<Cell>() ~ DeleteContainerAndItems!(_);

		private Cell[,] cellGrid = null ~ DeleteContainerAndItems!(_);
		private Cell[,] cellGridBuffer = null ~ DeleteContainerAndItems!(_);
		private bool[,] cellGridHighlighted = null ~ SafeDelete!(_);
		private Size2D gridSize = null ~ SafeDelete!(_);

		public Size2D GridSize { get { return gridSize; } }

		public bool mPauseSimulation = false;

		public this(Size2D imageSize) : base(imageSize)
		{
			int size = (int)imageSize.Width;
			cellGrid = new Cell[size, size];
			cellGridBuffer = new Cell[size, size];
			cellGridHighlighted = new bool[size, size];
			gridSize = new .(size, size);
		}

		public Cell GetCellAt(v2d<int> pos)
		{
			return cellGrid[pos.y, pos.x];
		}

		public Cell GetCellAt(int x, int y)
		{
			return cellGrid[y, x];
		}

		public Cell GetNextCellAt(v2d<int> pos)
		{
			return cellGridBuffer[pos.y, pos.x];
		}
		public Cell GetNextCellAt(int x, int y)
		{
			return cellGridBuffer[y, x];
		}

		public void Update()
		{
			/*for (var cell in cellGrid)
			{*/
			/*var lenghtY = cellGrid.GetLength(0);
			var lenghtX = cellGrid.GetLength(1);*/
			/*var lenghtY = [Friend]mSize.mY;
			var lenghtX = [Friend]mSize.mX;*/
			var maxIndex = (int)(this.[Friend]mSize.mX-1) * (int)(this.[Friend]mSize.mY-1);
			if (!mPauseSimulation || gGameApp.mFrameAdvance)
			{
				for (int i = maxIndex; i > 0; i--)
				{
				/*for (int y = (int)this.[Friend]mSize.mY - 1; y > 0; y--)
				{
					for (int x = (int)this.[Friend]mSize.mX - 1; x > 0; x--)
					{*/	int x = (int)(i % this.[Friend]mSize.mX);
					int y = (int)(i / this.[Friend]mSize.mX);
					Cell* cell = &cellGrid[y, x];
					if ((*cell) == null)
						continue;

					Cell c = (*cell);
					c.mLifeCycle++;
					if (c.mSleepTimer > 0)
						c.mSleepTimer--;
					if (c.mLifeCycle >= c.mNextUpdate && c.mSleepTimer == 0)
					{
						c.Think(this);
						if (c.mHasGravity)
							c.ProcessGravity(this);


						/*if (c.mHasGravity && (c.mVel.x != 0 || c.mVel.y != 0))
						{
							var offsetPos = c.GetOffSet(c.mVel.x, c.mVel.y);
							if (offsetPos.x >= 0 && offsetPos.y >= 0 && offsetPos.x < GridSize.Width && offsetPos.y < GridSize.Height)
								if (cellGrid[offsetPos.y, offsetPos.x] == null && cellGridBuffer[offsetPos.y, offsetPos.x] == null)
								{
									c.MoveToOffset(c.mVel.x, c.mVel.y, this);
								}
						}*/
						/*for (var thought in ListThought)
						{
							if (thought != null)
							{
								var t = thought.Value;
								t.SetOriginCell(cell);
								t.SetTargetCell(FindCellAt(t.TargetPos));
								updates.Add(t);
							}
						}*/
					}
				}


				for (int i = maxIndex; i > 0; i--)
				{
				/*for (int y = (int)this.[Friend]mSize.mY - 1; y > 0; y--)
				{
					for (int x = (int)this.[Friend]mSize.mX - 1; x > 0; x--)
					{*/	int x = (int)(i % this.[Friend]mSize.mX);
					int y = (int)(i / this.[Friend]mSize.mX);
					Cell* cell = &cellGrid[y, x];
					if ((*cell) == null)
						continue;

					Cell c = (*cell);

					if (c.mHasGravity && (c.mVel.x != 0 || c.mVel.y != 0))
					{
						uint16 timesNotMoved = 0;
						var tempVel = c.mVel;
						while (timesNotMoved < 10)
						{
							timesNotMoved++;
							var offsetPos = c.GetOffSet(tempVel.x, tempVel.y);
							if (offsetPos.x >= 0 && offsetPos.y >= 0 && offsetPos.x < GridSize.Width && offsetPos.y < GridSize.Height)
							{
								if (cellGrid[offsetPos.y, offsetPos.x] == null && cellGridBuffer[offsetPos.y, offsetPos.x] == null)
								{
									c.MoveToOffset(tempVel.x, tempVel.y, this);
									timesNotMoved = 100;
								}
								else
								{
									if (tempVel.x != 0)
									{
										if (tempVel.x > 0)
											tempVel.x -= 1;
										else
											tempVel.x += 1;
									} else if (tempVel.y != 0)
									{
										if (tempVel.y > 0)
											tempVel.y -= 1;
										else
											tempVel.y += 1;
									}
								}
							}
						}
						if (c.mVel.x != 0)
						{
							if (c.mVel.x > 0)
								c.mVel.x -= 1;
							else
								c.mVel.x += 1;
						}
						if (c.mVel.y != 0)
						{
							if (c.mVel.y > 0)
								c.mVel.y -= 1;
							else
								c.mVel.y += 1;
						}
					}
					//c.mVel.Set(0, 0);
				}

				/*for (var i in 0 ..< 1)
				{
					if (gGameApp.mRand.Next(0, 100) >= 75 && false)
					{
						for (var j in 0 ..< 5)
						{
							Cell c = new Sand(.(0, 0));
							AddCellAt(c, .(gGameApp.mRand.Next(0, (int32)gridSize.Width), gGameApp.mRand.Next(10, 400)));
						}
					}
					if (gGameApp.mRand.Next(0, 100) >= 75 && false)
					{
						Cell c = new Vine(.(0, 0));
						AddCellAt(c, .(gGameApp.mRand.Next(0, (int32)gridSize.Width), gGameApp.mRand.Next(0, (int32)gridSize.Height)));
					}
					if (gGameApp.mRand.Next(0, 100) >= 90 && false)
					{
						v2d<int> tPos = .(gGameApp.mRand.Next(0, (int32)gridSize.Width), gGameApp.mRand.Next(0, (int32)gridSize.Height));
						var neighborCell = GetCellAt(tPos);
						if (neighborCell is Tree || neighborCell is Vine)
						{
							Cell c = new Fire(tPos);
							AddCellAt(c, tPos);
						}
					}
				}*/
				
			}
			for (int i = maxIndex; i > 0; i--)
			{
			/*for (int y = (int)this.[Friend]mSize.mY - 1; y > 0; y--)
			{
				for (int x = (int)this.[Friend]mSize.mX - 1; x > 0; x--)
				{*/	int x = (int)(i % this.[Friend]mSize.mX);
				int y = (int)(i / this.[Friend]mSize.mX);
				Cell* originalCell = &cellGrid[y, x];
				if (cellGridBuffer[y, x] != null)
				{
					Cell* newCell = &cellGridBuffer[y, x];
					delete (*originalCell);
					cellGrid[y, x] = (*newCell);
					(*originalCell) = (*newCell);
					cellGridBuffer[y, x] = null;
				}
				if ((*originalCell) != null && (*originalCell).mMarkDelete)
				{
					delete (*originalCell);
					cellGrid[y, x] = null;
				}
			}
		}



		public void AddCellMaybeAt(Cell c, v2d<int> pos)
		{
			if (cellGridBuffer[pos.y, pos.x] != null)
				delete cellGridBuffer[pos.y, pos.x];

			cellGridBuffer[pos.y, pos.x] = c;
			c.mPos.Set(pos);
		}

		public void AddCellAt(Cell c, v2d<int> pos)
		{
			if (cellGridBuffer[pos.y, pos.x] != null)
				delete cellGridBuffer[pos.y, pos.x];

			cellGridBuffer[pos.y, pos.x] = c;
			c.mPos.Set(pos);
		}

		public void MoveCellTo(v2d<int> fromPos, v2d<int> toPos)
		{
			if (cellGrid[fromPos.y, fromPos.x] != null)
			{
			}
			cellGridBuffer[toPos.y, toPos.x] = cellGrid[fromPos.y, fromPos.x];
			cellGrid[fromPos.y, fromPos.x] = null;
		}

		public void ClearCell(v2d<int> pos)
		{
			if (cellGridBuffer[pos.y, pos.x] != null)
				delete cellGridBuffer[pos.y, pos.x];
			cellGridBuffer[pos.y, pos.x] = null;
			cellGrid[pos.y, pos.x]?.mMarkDelete = true;
		}

		public void AddHighlightedCell(v2d<int> pos)
		{
			cellGridHighlighted[pos.y, pos.x] = true;
		}

		public void RemoveHighlightedCell(v2d<int> pos)
		{
			cellGridHighlighted[pos.y, pos.x] = false;
		}
		public void ToggleHighlightedCell(v2d<int> pos)
		{
			cellGridHighlighted[pos.y, pos.x] = !cellGridHighlighted[pos.y, pos.x];
		}

		public override void RenderLoop(int32 pixelStep, SDL2.Image image, uint32* data)
		{
			//base.RenderLoop(pixelStep, image, data);
			//int halfPixelStep = pixelStep / 2;
			/*for (var cell in cellGrid)
			{*/
			SDL2.SDL.PixelFormat* fmt = image.mSurface.format;
			SDL2.SDL.Color DefaultColor = .(64, 32, 0, 255);


			Stopwatch sw = scope Stopwatch();
			sw.Start();
			SDL2.SDL.Color color = DefaultColor;
			for (int i = (int)(this.[Friend]mSize.mX * this.[Friend]mSize.mY); i > 0; i--)
			{
				int x = Math.Max(i % (image.mSurface.w) - 1, 0);
				int y = Math.Max(i / (image.mSurface.w) - 1, 0);
				color = DefaultColor;
				if (cellGrid[y, x] != null)
					color = cellGrid[y, x].mColor;

				if (cellGridHighlighted[y, x])
				{
					cellGridHighlighted[y, x] = false;
					var b = 150;
					var g = 100;
					var r = g;

					color.b = (uint8)Math.Min(255, color.b + b);
					color.g = (uint8)Math.Min(255, color.g + g);
					color.r = (uint8)Math.Min(255, color.r + r);
				}
					/*var xPos = cell.mPos.x - halfPixelStep;
					var yPos = cell.mPos.y - halfPixelStep;
					if (xPos < 0 || yPos < 0)
						continue;*/
					//[Friend]SetPixel((uint32*)data, image, x, y, color);
				(data)[(image.mSurface.w) * y + x] = ((uint32)color.r << fmt.rshift | (uint32)color.g << fmt.gshift | (uint32)color.b << fmt.bshift) | (uint32)color.a;
				//}
			}
			sw.Stop();
			logCurrentTime(sw.ElapsedMicroseconds);
		}
	}
}
