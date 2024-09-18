using BasicEngine;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell.Brains
{
	class FireBrain : CellBrain
	{
		public this()
		{
			this.type = 2;
		}

		public override List<CellIntent?> Think(Cell me)
		{
			base.Think(me);
			List<CellIntent?> ciList = new List<CellIntent?>();

			if (me.mLifeCycle >= 10)
			{
				v2d<int> tPos = .(0, 0);
				for (var yOffSet = -1; yOffSet < 2; yOffSet++)
					for (var xOffSet = -1; xOffSet < 2; xOffSet++)
					{
						if (!(yOffSet == 0 && xOffSet == 0))
						{
							tPos.Set(me.mPos.x + xOffSet, me.mPos.y + yOffSet);
							if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < 1024 && tPos.y < 1024)
							{
								var ci = CellIntent(me, .FilteredReplace, tPos);
								ci.SetTargetType(1);
								ciList.Add(ci);
							}
						}
					}
			}
			if (me.mLifeCycle > 30)
			{
				var ci = CellIntent(me, .KillCell, me.mPos);
				ciList.Add(ci);
			}

			return ciList;
		}

		public override CellBrain Create()
		{
			return new FireBrain();
		}
	}
}
