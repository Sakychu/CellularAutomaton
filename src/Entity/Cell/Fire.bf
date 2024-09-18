using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
using System;
namespace CelluarAutomaton.Entity.Cell
{
	class Fire : Cell
	{
		public this(v2d<int> pos) : base(pos, .(200, 0, 0, 255))
		{
			mSleepTimer = gGameApp.mRand.Next(0, 2);
			mPlacecost = 0;
		}

		public override CellTypes ID
		{
			get
			{
				return .Fire;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			var dimAmount = gGameApp.mRand.Next(0,20)-10*2;
			if(((int)mColor.r + dimAmount) > 256)
				mColor.r = 255;
			else
				OffSetColor(dimAmount, 0, 0);

			if (mLifeCycle < 4)
			{
				v2d<int> tPos = .(0, 0);
				int randi = 1;
				for (var yOffSet = -randi; yOffSet <= randi; yOffSet++)
				{
					for (var xOffSet = -randi; xOffSet <= randi; xOffSet++)
					{
						if (!(yOffSet == 0 && xOffSet == 0))
						{
							tPos.Set(mPos.x + xOffSet, mPos.y + yOffSet);
							if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < playfield.GridSize.Width && tPos.y < playfield.GridSize.Height)
							{
								var neighborCell = playfield.GetCellAt(tPos);
								if(neighborCell is Tree || neighborCell is Vine)
								{
									Cell c = new Fire(tPos);
									playfield.AddCellAt(c, tPos);
								}
								if(let neighborBomb = neighborCell as Bomb)
								{
									neighborBomb.[Friend]shouldExplode = true;
								}
								if(let neighborBomb = neighborCell as Grenade)
								{
									neighborBomb.[Friend]shouldExplode = true;
								}
							}
						}
					}
				}
			}
			if (mLifeCycle > 6)
			{
				playfield.ClearCell(mPos);
				//Cell c = new Sand(mPos);
				//playfield.AddCellAt(c, mPos);
			}

		}
	}
}