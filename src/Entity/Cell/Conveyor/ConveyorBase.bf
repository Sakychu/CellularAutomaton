using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class ConveyorBase : Cell
	{
		protected int moveDir = 0;
		public this(v2d<int> pos) : base(pos, .(220, 220, 220, 255))
		{
			mRemovalcost = 1;
			mPlacecost = 0;
			mRemovable = true;
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
			if(mLifeCycle % 1 == 0)
			{
				var offsetPos = GetOffSet(0, -1);
				Cell c = playfield.GetCellAt(offsetPos);
				if(c != null)
					c.mVel.x = moveDir;
			}

			var cycleSize = 7;
			var cycles = (int)gGameApp.mLogicCycleCounter - ((mPos.x % cycleSize) * moveDir);
			var unLitColor = 125;
			var litColor = 150;
			if((cycles % cycleSize) == 0 || (cycles % cycleSize) == 1 || (cycles % cycleSize) == 2)
			{
				mColor.r = (uint8)unLitColor;
				mColor.g = (uint8)unLitColor;
				mColor.b = (uint8)unLitColor;
			}else
			{
				mColor.r = (uint8)litColor;
				mColor.g = (uint8)litColor;
				mColor.b = (uint8)litColor;
			}
		}
	}
}