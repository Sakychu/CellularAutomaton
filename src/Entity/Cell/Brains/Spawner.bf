using BasicEngine;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell.Brains
{
	class Spawner : CellBrain
	{
		public override List<CellIntent?> Think(Cell me)
		{
			base.Think(me);

			CellIntent? ci = null;
			if (gGameApp.mRand.Next(0, 100) == 1)
			{
				v2d<int> tPos = .(0, 0);
				var xOffSet = gGameApp.mRand.Next(0, 3) - 1;
				var yOffSet = gGameApp.mRand.Next(0, 3) - 1;
				if(!(yOffSet == 0 && xOffSet == 0))
				{
					tPos.Set(me.mPos.x + xOffSet, me.mPos.y + yOffSet);
					ci = CellIntent(me, .Spread, tPos);
				}
			}

			return null;
		}

		public override CellBrain Create()
		{
			return new Spawner();
		}
	}
}
