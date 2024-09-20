using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Ore : Cell
	{
		public this(v2d<int> pos) : base(pos, .(130, 130, 130, 255))
		{
			mHasGravity = true;
			int max = 75;
			{
				uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, max) - (uint8)(max/2);
				colorOffset *= 2;
				mColor.r += colorOffset;
			}
			{
				uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, max) - (uint8)(max/2);
				colorOffset *= 2;
				mColor.g += colorOffset;
			}
			{
				uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, max) - (uint8)(max/2);
				colorOffset *= 2;
				mColor.b += colorOffset;
			}//OffSetColor(colorOffset);
			mPlacecost = 1;
			mRemovalcost = 100;
			mRemovable = true;
		}

		public override CellTypes ID
		{
			get
			{
				return .Ore;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			/*
			int randomNumber = gGameApp.mRand.Next(0, 10000);
			if (randomNumber <= 2500)
			{
				
				var xOffSet = gGameApp.mRand.Next(-1, 2);
				var yOffSet = gGameApp.mRand.Next(-1, 2);
				if (!(yOffSet == 0 && xOffSet == 0))
				{
					tPos.Set(mPos.x + xOffSet, mPos.y + yOffSet);
					if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < 1024 && tPos.y < 1024)
					{
						if (playfield.GetCellAt(tPos) == null)
						{
							Cell c = new TreeCell(tPos);
							playfield.AddCellAt(c, tPos);
						}
					}
				}
			} else if (randomNumber >= 9995)
			{
				Cell c = new FireCell(mPos);
				playfield.AddCellAt(c, mPos);
			}*/
		}
		
	}
}