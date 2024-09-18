using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class ConveyorVert : ConveyorBase
	{
		public this(v2d<int> pos) : base(pos)
		{
			moveDir = -1;
		}

		public override CellTypes ID
		{
			get
			{
				return .ConveyorVert;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			if(true)
			{
				var topPos = GetOffSet(0, -1);
				bool isTop = playfield.GetCellAt(topPos) == null || !(playfield.GetCellAt(topPos) is ConveyorVert);

				{
					var offsetPos = GetOffSet(1, 0);
					Cell c = playfield.GetCellAt(offsetPos);
					if(c != null)
					{
						c.mVel.y = -1;
						if(isTop)
							c.mVel.x = 1;
					}
				}
				{
					var offsetPos = GetOffSet(-1, 0);
					Cell c = playfield.GetCellAt(offsetPos);
					if(c != null)
					{
						c.mVel.y = -1;
						if(isTop)
							c.mVel.x = -1;
					}
				}

				if(isTop)
				{
					{
						var offsetPos = GetOffSet(1, 1);
						Cell c = playfield.GetCellAt(offsetPos);
						if(c != null)
						{
							c.mVel.y = -1;
							if(isTop)
								c.mVel.x = 1;
						}
					}
					{
						var offsetPos = GetOffSet(-1, 1);
						Cell c = playfield.GetCellAt(offsetPos);
						if(c != null)
						{
							c.mVel.y = -1;
							if(isTop)
								c.mVel.x = -1;
						}
					}
				}
			}

			var cycleSize = 7;
			var cycles = (int)gGameApp.mLogicCycleCounter - ((mPos.y % cycleSize) * moveDir);
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