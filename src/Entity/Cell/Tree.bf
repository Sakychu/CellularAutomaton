using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Tree : Cell
	{
		public this(v2d<int> pos) : base(pos, .(0, 255, 0, 255))
		{
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			int randomNumber = gGameApp.mRand.Next(0, 10000);
			if (randomNumber <= 2500)
			{
				v2d<int> tPos = .(0, 0);
				var xOffSet = gGameApp.mRand.Next(-1, 2);
				var yOffSet = gGameApp.mRand.Next(-1, 2);
				if (!(yOffSet == 0 && xOffSet == 0))
				{
					tPos.Set(mPos.x + xOffSet, mPos.y + yOffSet);
					if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < playfield.GridSize.Width && tPos.y < playfield.GridSize.Height)
					{
						if (playfield.GetCellAt(tPos) == null)
						{
							Cell c = new Tree(tPos);
							playfield.AddCellAt(c, tPos);
						}
					}
				}
			} else if (randomNumber >= 9997)
			{
				Cell c = new Fire(mPos);
				playfield.AddCellAt(c, mPos);
			}
		}
	}
}