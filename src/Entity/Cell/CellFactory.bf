using BasicEngine;
using System;
namespace CelluarAutomaton.Entity.Cell;

static class CellFactory
{
	static public Cell NewFromId(Cell.CellTypes? id)
	{
		v2d<int> pos = .(0, 0);

		if (id == null || id == .None)
			return new Sand(pos);

		switch (id)
		{
		case .Fire:
			return new Fire(pos);
		case .Sand:
			return new Sand(pos);
		case .Stone:
			return new Stone(pos);
		case .Tree:
			return new Tree(pos);
		case .Vine:
			return new Vine(pos);
		case .Unobstonium:
			return new Unobstonium(pos);
		case .ConveyorR:
			return new ConveyorR(pos);
		case .ConveyorL:
			return new ConveyorL(pos);
		case .ConveyorVert:
			return new ConveyorVert(pos);
		case .Shop:
			return new Shop(pos);
		case .Bomb:
			return new Bomb(pos);
		case .Grenade:
			return new Grenade(pos);
		case .Ore:
			return new Ore(pos);
		default:
			return new Sand(pos);
		}
	}

	static public bool IsPlacable(Cell.CellTypes id)
	{
		switch (id)
		{
		case .Fire:
			return true;
		case .Sand:
			return true;
		case .ConveyorL:
			return true;
		case .ConveyorR:
			return true;
		case .ConveyorVert:
			return true;
		case .Bomb:
			return true;
		case .Grenade:
			return false;
		case .Vine:
			return true;
		default:
			return false;
		}
	}

	static public void IDtoString(Cell.CellTypes id, String strBuffer)
	{
		switch (id)
		{
		case .None:
			strBuffer.Append("None");
		case .Fire:
			strBuffer.Append("Fire");
		case .Sand:
			strBuffer.Append("Sand");
		case .Stone:
			strBuffer.Append("Stone");
		case .Tree:
			strBuffer.Append("Tree");
		case .Vine:
			strBuffer.Append("Vine");
		case .Shop:
			strBuffer.Append("Shop");
		case .ConveyorL:
			strBuffer.Append("Conveyor Left");
		case .ConveyorR:
			strBuffer.Append("Conveyor Right");
		case .ConveyorVert:
			strBuffer.Append("Conveyor Vert.");
		case .Unobstonium:
			strBuffer.Append("Unobstonium");
		case .Bomb:
			strBuffer.Append("Bomb");
		case .Grenade:
			strBuffer.Append("Grenade");
			default:
			strBuffer.Append("err");
		}
	}
}