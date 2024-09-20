using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Gravel : Cell
	{
		uint8 startRed = 110;
		public this(v2d<int> pos) : base(pos, .(110, 110, 110, 255))
		{
			OffSetColor(50);

			uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, 20) - 10;
			colorOffset *= 2;
			OffSetColor(colorOffset);
			startRed = mColor.r;
			mPlacecost = 1;
			mRemovalcost = 1;
			mRemovable = true;
			mHasGravity = true;
			mMaxTmp = 100;
		}

		public override CellTypes ID
		{
			get
			{
				return .Gravel;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			var basecolor = startRed;
			if(mTmp > 0)
			{
				var dimAmount = (255-basecolor) * mTmp/mMaxTmp;
				mColor.r = (uint8)System.Math.Min(255, basecolor + dimAmount);
				if(mTmp > mMaxTmp)
				{
					/*Cell selfExplode = new Explosion(mPos, .Sand);
					playfield.AddCellAt(selfExplode, mPos);
					selfExplode.mSleepTimer = 2;*/
				}
			}
			else
				mColor.r = basecolor;
		}
		
	}
}