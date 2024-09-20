using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
using System;
namespace CelluarAutomaton.Entity.Cell
{
	class Vine : Cell
	{
		public this(v2d<int> pos) : base(pos, .(0, 255, 0, 255))
		{
			mPlacecost = 1;
		}

		public override CellTypes ID
		{
			get
			{
				return .Vine;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			v2d<int> tPos = .(0, 0);
			var xOffSet = gGameApp.mRand.Next(-1, 2);
			var yOffSet = gGameApp.mRand.Next(-1, 2);
			if (!(yOffSet == 0 && xOffSet == 0))
			{
				tPos.Set(mPos.x + xOffSet, mPos.y + yOffSet);
				if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < playfield.GridSize.Width && tPos.y < playfield.GridSize.Height)
				{
					Cell targetCell = playfield.GetCellAt(tPos);
					if (targetCell == null && playfield.GetNextCellAt(tPos) == null)
					{
						Cell c = new Vine(tPos);
						c.mSleepTimer = gGameApp.mRand.Next(50, 100);
						playfield.AddCellAt(c, tPos);
					}
					else if (targetCell != null && targetCell.ID == .Stone && gGameApp.mRand.GetChance(0.2))
					{
						Cell c = new Vine(tPos);
						c.mSleepTimer = gGameApp.mRand.Next(50, 100);
						playfield.AddCellAt(c, tPos);
					}
				}
			}
			mSleepTimer = gGameApp.mRand.Next(50, 500);

			OffSetColor(0, -5, 0);
			mColor.g = Math.Max(5, mColor.g);
		}
	}
}