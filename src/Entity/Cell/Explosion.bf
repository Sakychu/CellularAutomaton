using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Explosion : Cell
	{
		private CellTypes mTurnTo = .None;
		private Cell turnToCell = null;
		public this(v2d<int> pos, CellTypes turnTo = .None) : base(pos, .(128, 32, 32, 128))
		{
			mSleepTimer = 4;
			if(turnTo != .None)
			{
				//turnToCell = CellFactory.NewFromId(turnTo);
				mTurnTo = turnTo;
			}
		}

		public override CellTypes ID
		{
			get
			{
				return .None;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			if(mTurnTo != .None)
			{
				Cell c = CellFactory.NewFromId(mTurnTo);
				c.mTmp = mTmp;
				playfield.AddCellAt(c, mPos);
			}
			else
				playfield.ClearCell(mPos);
		}
	}
}