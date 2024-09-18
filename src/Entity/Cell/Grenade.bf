using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
using System;
namespace CelluarAutomaton.Entity.Cell
{
	class Grenade : Cell
	{
		bool shouldExplode = false;

		public this(v2d<int> pos) : base(pos, .(193, 154, 107, 255))
		{
			mSleepTimer = gGameApp.mRand.Next(0, 2);
			mPlacecost = 0;
			mRemovable = true;
			mHasGravity = true;
		}

		public override CellTypes ID
		{
			get
			{
				return .Grenade;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			if (shouldExplode)
			{
				v2d<int> tPos = .(0, 0);
				int radi = 6;
				//playfield.ClearCell(mPos);
				Cell selfExplode = new Explosion(mPos);
				playfield.AddCellAt(selfExplode, mPos);
				selfExplode.mSleepTimer = 2;
				for (var yOffSet = -radi; yOffSet <= radi; yOffSet++)
				{
					for (var xOffSet = -radi; xOffSet <= radi; xOffSet++)
					{
						var actualRadi = Math.Sqrt(Math.Abs(xOffSet*xOffSet)+Math.Abs(yOffSet*yOffSet));
						if(radi < actualRadi)
							continue;

						tPos.Set(mPos.x + xOffSet, mPos.y + yOffSet);
						if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < playfield.GridSize.Width && tPos.y < playfield.GridSize.Height)
						{
							Explosion c = null;

							var neighborCell = playfield.GetCellAt(tPos);
							if (neighborCell is Stone)
							{
								c = new Explosion(mPos, .Sand);
							}
							else if (neighborCell is Vine)
							{
								c = new Explosion(mPos, .Fire);
							}
							else if (neighborCell is Fire)
							{
								c = new Explosion(mPos);
							}
							else if (neighborCell is Sand)
							{
								c = new Explosion(mPos, .Sand);
							}
							else if (let neighborBomb = neighborCell as Bomb)
							{
								if(!neighborBomb.[System.Friend]shouldExplode)
								{
									neighborBomb.[System.Friend]shouldExplode = true;
									neighborBomb.mSleepTimer = (int)Math.Ceiling(actualRadi)+1;
								}
								
							}else if (let neighborBomb = neighborCell as Grenade)
							{
								if(!neighborBomb.[System.Friend]shouldExplode)
								{
									neighborBomb.[System.Friend]shouldExplode = true;
									neighborBomb.mSleepTimer = (int)Math.Ceiling(actualRadi)+1;
								}
								
							}
							else if(let neighborExplosion = neighborCell as Explosion)
							{
								neighborExplosion.mSleepTimer += 2;
							}

							if (c == null && neighborCell == null)
							{
								c = new Explosion(mPos);
							}
							if (c != null)
							{
								playfield.AddCellAt(c, tPos);
								//c.mSleepTimer = (int)Math.Remap(Math.Ceiling(actualRadi),radi,1,1,radi);
								//c.mSleepTimer = (int)Math.Remap(Math.Ceiling(actualRadi),1,radi,radi,1);
								c.mSleepTimer = (int)Math.Ceiling(actualRadi)+1;
							}
						}
					}
				}
			}
		}
	}
}