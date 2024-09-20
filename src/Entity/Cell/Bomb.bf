using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
using System;
namespace CelluarAutomaton.Entity.Cell
{
	class Bomb : Cell
	{
		bool shouldExplode = false;

		public this(v2d<int> pos) : base(pos, .(255, 32, 32, 255))
		{
			mSleepTimer = gGameApp.mRand.Next(0, 2);
			mPlacecost = 100;
			mRemovable = true;
			mHasGravity = false;
		}

		public override CellTypes ID
		{
			get
			{
				return .Bomb;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			if (shouldExplode)
			{
				v2d<int> tPos = .(0, 0);
				int radi = 16;
				Cell selfExplode = new Explosion(mPos);
				playfield.AddCellAt(selfExplode, mPos);
				selfExplode.mSleepTimer = radi+1;

				for (var i = 0; i < (360); i += (360 / 90))
				{
					bool hitNonBreakable = false;
					for (float r = 0; r <= radi; r+=1f)
					{
						var x1 = r * Math.Cos(i * Math.PI_d / 180);
						var y1 = r * Math.Sin(i * Math.PI_d / 180);
						tPos.Set((int)(mPos.x + x1), (int)(mPos.y + y1));

						if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < playfield.GridSize.Width && tPos.y < playfield.GridSize.Height)
						{
							Explosion c = null;

							var neighborCell = playfield.GetCellAt(tPos);
							if(neighborCell != null)
								neighborCell.mTmp += Math.Remap(r, 0, radi, 15f, 0f);
							if (let neighborBomb = neighborCell as Bomb)
							{
								if (!neighborBomb.[System.Friend]shouldExplode)
								{
									neighborBomb.[System.Friend]shouldExplode = true;
									neighborBomb.mSleepTimer = (int)Math.Ceiling(r) + 1;
								}
							}
							else if (let neighborExplosion = neighborCell as Explosion)
							{
								neighborExplosion.mSleepTimer += 2;
								if(neighborExplosion.mSleepTimer > 128)
									neighborExplosion.mSleepTimer -= 12;
							}

							if (neighborCell is ConveyorBase || neighborCell is Unobstonium || neighborCell is Shop)
							{
								hitNonBreakable = true;
							}

							if (c == null && neighborCell == null && !hitNonBreakable)
							{
								c = new Explosion(mPos);
							}

							if (c != null)
							{
								playfield.AddCellAt(c, tPos);
								//c.mSleepTimer = (int)Math.Remap(Math.Ceiling(actualRadi),radi,1,1,radi);
								//c.mSleepTimer = (int)Math.Remap(Math.Ceiling(actualRadi),1,radi,radi,1);
								c.mSleepTimer = (int)Math.Ceiling(r) + 1;
							}

							if (hitNonBreakable)
							{
								break;
							}
						}
					}
				}
			}
		}
	}
}