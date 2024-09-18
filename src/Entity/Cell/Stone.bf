using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Stone : Cell
	{
		public this(v2d<int> pos) : base(pos, .(110, 110, 110, 255))
		{
			uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, 20) - 10;
			colorOffset *= 2;
			OffSetColor(colorOffset);
			mPlacecost = 100;
			mRemovalcost = 100;
			mRemovable = true;
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
		}
	}
}