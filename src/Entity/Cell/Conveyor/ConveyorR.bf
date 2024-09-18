using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
namespace CelluarAutomaton.Entity.Cell
{
	class ConveyorR : ConveyorBase
	{
		public this(v2d<int> pos) : base(pos)
		{
			moveDir = 1;
		}

		public override CellTypes ID
		{
			get
			{
				return .ConveyorR;
			}
		}
	}
}