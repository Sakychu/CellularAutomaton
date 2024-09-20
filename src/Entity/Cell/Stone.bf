using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Stone : Cell
	{
		uint8 startRed = 110;
		public this(v2d<int> pos) : base(pos, .(110, 110, 110, 255))
		{
			uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, 20) - 10;
			colorOffset *= 2;
			OffSetColor(colorOffset);
			startRed = mColor.r;
			mPlacecost = 100;
			mRemovalcost = 100;
			mRemovable = true;
			mMaxTmp = 100f;
		}

		public override CellTypes ID
		{
			get
			{
				return .Stone;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			var basecolor = startRed;
			if(mTmp > 0)
			{
				var dimAmount = (255-basecolor) * mTmp/mMaxTmp;
				mColor.r = (uint8)(basecolor + dimAmount);
				if(mTmp > mMaxTmp)
				{
					Cell selfExplode = new Explosion(mPos, .Gravel);
					selfExplode.mTmp = mTmp;
					playfield.AddCellAt(selfExplode, mPos);
					selfExplode.mSleepTimer = 2;
				}
			}
			else
				mColor.r = basecolor;
			//OffSetColor(0,0,0);
		}
	}
}