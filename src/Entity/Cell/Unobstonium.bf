using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class Unobstonium : Cell
	{
		public this(v2d<int> pos) : base(pos, .(75, 75, 75, 255))
		{
			uint8 colorOffset = (uint8)gGameApp.mRand.Next(0, 30) - 15;
			colorOffset *= 2;
			OffSetColor(colorOffset);
			mPlacecost = 0;
			mRemovalcost = 0;
		}

		public override CellTypes ID
		{
			get
			{
				return .Unobstonium;
			}
		}

		public override void Think(CelluarAutomatonObj playfield)
		{
		}
	}
}