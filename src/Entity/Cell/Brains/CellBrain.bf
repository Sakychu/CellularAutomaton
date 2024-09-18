using BasicEngine;
using System.Collections;

namespace CelluarAutomaton.Entity.Cell.Brains
{
	class CellBrain
	{
		protected int type = 0;
		public int BrainType { get { return type; } };

		int moveCD = 0;
		int maxMoveCD = 30;

		protected this()
		{
		}

		public virtual List<CellIntent?> Think(Cell me)
		{
			if (type == 0)
			{
				Log!("Err");
			}

			List<CellIntent?> ci = null;
			/*if (gGameApp.mRand.Next(0, 10) == 1)
			{
				v2d<int> tPos = .(0, 0);
				var xOffSet = gGameApp.mRand.Next(0, 3) - 1;
				var yOffSet = gGameApp.mRand.Next(0, 3) - 1;
				if (!(yOffSet == 0 && xOffSet == 0))
				{
					tPos.Set(me.mPos.x + xOffSet, me.mPos.y + yOffSet);

					ci = CellIntent(me, .Move, tPos);
				}
			}*/
			return ci;
		}

		public virtual CellBrain Create()
		{
			return new CellBrain();
		}
	}


	public struct CellIntent
	{
		public enum Intents : uint32
		{
			None,
			Move,
			Spread,
			Replace,
			FilteredReplace,
			KillCell
		}

		private Cell targetCell;
		public Cell TargetCell { get { return targetCell; } }

		private int targetType = -1;
		public int TargetType { get { return targetType; } }

		private Cell originCell;
		public Cell OriginCell { get { return originCell; } }

		private Intents intent = .None;
		public Intents Intent { get { return intent; } }

		private v2d<int> targetPos = default;
		public v2d<int> TargetPos { get { return targetPos; } }

		public this(Intents i, v2d<int> tPos)
		{
			originCell = null;
			targetCell = null;
			intent = i;
			targetPos.Set(tPos);
		}

		public this(Cell me, Intents i, v2d<int> tPos)
		{
			originCell = me;
			targetCell = null;
			intent = i;
			targetPos.Set(tPos);
		}

		public void SetOriginCell(Cell cell) mut
		{
			originCell = cell;
		}

		public void SetTargetCell(Cell cell) mut
		{
			targetCell = cell;
		}

		public void SetTargetType(int id) mut
		{
			targetType = id;
		}
	}
}
