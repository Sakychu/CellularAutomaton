using BasicEngine;
using System.Collections;
using CelluarAutomaton.Entity.Cell;
using CelluarAutomaton.Entity.Cell.Brains;
using BasicEngine.Collections;
using System.Diagnostics;

namespace CelluarAutomaton.Entity
{
	class ObjCelluarAutomaton : RawPixelDrawable
	{
		public List<Cell> lCells = new List<Cell>() ~ DeleteContainerAndItems!(_);

		private List<Cell> toDelete = null;
		public Cell[,] cellGrid = null ~ SafeDelete!(_);

		public this(Size2D size) : base(size)
		{
			cellGrid = new Cell[1024,1024];
		}

		public void MarkCellToDelete(Cell c)
		{
			toDelete.Add(c);
		}

		public Cell FindCellAt(v2d<int> pos)
		{
			Cell ret = cellGrid[pos.y, pos.x];

			return ret;
		}

		public void SetCellAt(Cell c, v2d<int> pos)
		{
			var FoundCell = FindCellAt(c.mPos);
			if (FoundCell != null)
			{
				RemoveCell(FoundCell);
			}	
			cellGrid[pos.y,pos.x] = c;
			cellGrid[c.mPos.y,c.mPos.x] = null;

			c.SetGridPos(pos);
		}

		public void AddCellAt(Cell c, v2d<int> pos)
		{
			cellGrid[pos.y,pos.x] = c;
			lCells.Add(c);
			c.SetGridPos(pos);
		}

		public void CopyCellTo(Cell original, v2d<int> targetPos)
		{
			var cell = new Cell(original);
			AddCellAt(cell, targetPos);
		}

		
		public void RemoveCell(Cell c)
		{
			cellGrid[c.mPos.y,c.mPos.x] = null;
			lCells.Remove(c);
			MarkCellToDelete(c);
		}	

		public void Update()
		{
			Stopwatch sw = scope Stopwatch();
			sw.Start();

			toDelete = new List<Cell>();
			List<CellIntent> updates = scope List<CellIntent>();
			for (var cell in lCells)
			{
				var thought = cell.Think();
				for(var t in thought)
				{
					var update = t.Value;
					update.SetOriginCell(cell);
					updates.Add(update);
				}
				SafeDelete!(thought);
			}

			for(var i in 0..<1)
			{
				if(gGameApp.mRand.Next(0, 100) >= 75)
				{
					var cell = new Cell(0, 255, 0);
					//cell.SetGridPos(gGameApp.mRand.Next(0,gGameApp.mScreen.w),gGameApp.mRand.Next(0,gGameApp.mScreen.h));
					cell.SetBrain(new Tree());
					AddCellAt(cell, .(gGameApp.mRand.Next(0,gGameApp.mScreen.w),gGameApp.mRand.Next(0,gGameApp.mScreen.h)));
				}
			}

			for (var update in updates)
			{
				switch (update.Intent)
				{
				case .Move:
					MoveCellTo(update);
					break;

				case .Spread:
					CopyCellTo(update);
					break;

				case .KillCell:
					RemoveCell(update.OriginCell);

				case .FilteredReplace:
					ReplaceCellIf(update);
				default:
					break;
				}
			}
			DeleteContainerAndItems!(toDelete);


			sw.Stop();
			logCurrentTime(sw.ElapsedMicroseconds);
		}

		private void MoveCellTo(CellIntent ci)
		{
			if (FindCellAt(ci.TargetPos) == null)
			{
				SetCellAt(ci.OriginCell, ci.TargetPos);
			}
		}

		private void ReplaceCellIf(CellIntent ci)
		{
			var FoundCell = FindCellAt(ci.TargetPos);
			if (FoundCell?.mBrain.BrainType == ci.TargetType)
			{
				RemoveCell(FoundCell);
				CopyCellTo(ci.OriginCell, ci.TargetPos);
			}	
		}	

		private void CopyCellTo(CellIntent ci)
		{
			if (FindCellAt(ci.TargetPos) == null)
			{
				CopyCellTo(ci.OriginCell, ci.TargetPos);
			}
		}

		public override void RenderLoop(int32 pixelStep, SDL2.Image image, uint32* data)
		{
			//base.RenderLoop(pixelStep, image, data);
			var halfPixelStep = pixelStep / 2;
			for (var cell in lCells)
			{
				var xPos = cell.mPos.x - halfPixelStep;
				var yPos = cell.mPos.y - halfPixelStep;
				if (xPos < 0 || yPos < 0)
					continue;
				SetCell(xPos, yPos, pixelStep, image, data, cell.mColor);
			}
		}
	}
}
