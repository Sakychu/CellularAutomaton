using BasicEngine;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell.Brains
{
	class TreeBrain : CellBrain
	{
		public this()
		{
			this.type = 1;
		}

		public override List<CellIntent?> Think(Cell me)
		{
			base.Think(me);
			List<CellIntent?> ciList = new List<CellIntent?>();
			int randomNumber = gGameApp.mRand.Next(0, 1000);
			if (randomNumber <= 25)
			{
				v2d<int> tPos = .(0, 0);
				var xOffSet = gGameApp.mRand.Next(0, 4) - 2;
				var yOffSet = gGameApp.mRand.Next(0, 4) - 2;
				if(!(yOffSet == 0 && xOffSet == 0))
				{
					tPos.Set(me.mPos.x + xOffSet, me.mPos.y + yOffSet);
					if(tPos.x >= 0 && tPos.y >= 0 && tPos.x < 1024 && tPos.y < 1024)
						ciList.Add(CellIntent(me, .Spread, tPos));
				}
			} else if(randomNumber >= 990)
			{
				//Cell c = new Cell(255,0,0);
				me.SetBrain(new FireBrain());
				me.SetColor(255,0,0);
				//ci = CellIntent(c, .Replace, me.mPos);
			}

			return ciList;
		}

		public override CellBrain Create()
		{
			return new TreeBrain();
		}
	}
}
