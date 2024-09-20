using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
using System;
namespace CelluarAutomaton.Entity.Cell
{
	class Shop : Cell
	{
		public this(v2d<int> pos) : base(pos, .(25, 25, 25, 255))
		{
			/*uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, 20) - 10;
			colorOffset *= 2;
			OffSetColor(colorOffset);*/
		}

		public override CellTypes ID
		{
			get
			{
				return .Shop;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
			for (var yOffSet = -1; yOffSet <= 1; yOffSet++)
			{
				for (var xOffSet = -1; xOffSet <= 1; xOffSet++)
				{
					var pos = GetOffSet(xOffSet,yOffSet);
					if (pos.x >= 0 && pos.y >= 0 && pos.x < playfield.GridSize.Width && pos.y < playfield.GridSize.Height)
					{
						Cell nearbyCell = playfield.GetCellAt(pos);
						if(nearbyCell != null && nearbyCell.ID != .Shop && nearbyCell.ID != .Unobstonium)
						{
							((CelluarAutomaton.Rendering)gGameApp.mGameState).[Friend]money += 1;
							if(nearbyCell.ID == .Ore)
								((CelluarAutomaton.Rendering)gGameApp.mGameState).[Friend]money += 9;
							playfield.ClearCell(pos);
						}
					}
				}
			}
		}
	}
}