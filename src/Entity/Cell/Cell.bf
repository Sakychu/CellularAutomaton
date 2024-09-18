using BasicEngine;
using CelluarAutomaton.Entity.Cell.Brains;
using System.Collections;
using System;
namespace CelluarAutomaton.Entity.Cell
{
	class Cell
	{
		public uint64 mRemovalcost = 0;
		public bool mRemovable = false;
		public uint64 mPlacecost = 0;

		public int mLifeCycle = 0;
		public int mNextUpdate = 0;
		public int mSleepTimer = 0;
		public v2d<int> mPos;
		public SDL2.SDL.Color mColor;
		public CellBrain mBrain = null ~ SafeDelete!(_);

		public bool mMarkDelete = false;

		public bool mHasGravity = false;
		public v2d<int> mVel = .(0, 0);

		public virtual CellTypes ID { get { return .None; } }

		public this()
		{
			mColor = SDL2.SDL.Color();
			mPos = .(0, 0);
		}

		public this(Cell other)
		{
			mColor = other.mColor;
			mPos.Set(other.mPos);
			if (other.mBrain != null)
			{
				mBrain = other.mBrain.Create();
			}
		}

		public this(int r, int g, int b)
		{
			SetColor(r, g, b);
		}

		public this(int x, int y)
		{
			SetGridPos(x, y);
		}

		public this(v2d<int> pos, SDL2.SDL.Color color)
		{
			mPos.Set(pos);
			mColor = color;
		}

		public void MoveToOffset<t>(int xOffSet, int yOffSet, CelluarAutomatonObj playfield) where t : Cell
		{
			if (!(yOffSet == 0 && xOffSet == 0))
			{
				var tPos = GetOffSet(xOffSet, yOffSet);
				if (tPos.x >= 0 && tPos.y >= 0 && tPos.x < playfield.GridSize.Width && tPos.y < playfield.GridSize.Height)
				{
					if (playfield.GetCellAt(tPos) == null && playfield.GetNextCellAt(tPos) == null)
					{
						Cell c = new t(tPos);
						playfield.AddCellAt(c, tPos);
						playfield.ClearCell(mPos);
					}
				}
			}
		}

		public void MoveToOffset(int xOffSet, int yOffSet, CelluarAutomatonObj playfield)
		{
			var offset = GetOffSet(xOffSet, yOffSet);
			playfield.MoveCellTo(mPos, offset);
			mPos.Set(offset);
		}

		public v2d<int> GetOffSet(int xOffSet, int yOffSet)
		{
			return .(mPos.x + xOffSet, mPos.y + yOffSet);
		}

		public void OffSetColor(int rOffset, int gOffset, int bOffset)
		{
			mColor.r += (uint8)rOffset;
			mColor.g += (uint8)gOffset;
			mColor.b += (uint8)bOffset;
		}

		public void OffSetColor(int Offset)
		{
			mColor.r += (uint8)Offset;
			mColor.g += (uint8)Offset;
			mColor.b += (uint8)Offset;
		}


		public void SetColor(int r, int g, int b)
		{
			mColor = SDL2.SDL.Color((uint8)r, (uint8)g, (uint8)b, 255);
		}

		public void SetGridPos(int x, int y)
		{
			mPos.Set(x, y);
		}

		public void SetGridPos(v2d<int> pos)
		{
			mPos.Set(pos);
		}

		public void SetBrain(CellBrain brain)
		{
			SafeDelete!(mBrain);
			mBrain = brain;
		}

		public void NextCycle(CelluarAutomatonObj playfield)
		{
			mLifeCycle++;
			Think(playfield);
		}

		public virtual List<CellIntent?> ThinkBrain()
		{
			mLifeCycle++;
			return mBrain?.Think(this);
		}

		public virtual void Think(CelluarAutomatonObj playfield)
		{
		}

		public virtual void ProcessGravity(CelluarAutomatonObj playfield)
		{
			var offsetPos = GetOffSet(0, 1);
			if (offsetPos.y >= (playfield.GridSize.Height) || mVel.y != 0 || mVel.x != 0)
				return;

			mVel.y = 1;

			bool middleEmpty = playfield.GetCellAt(offsetPos) == null;
			if (!middleEmpty)
			{
				int randomNumber = gGameApp.mRand.Next(0, 100);
				bool rightEmpty = ((offsetPos.x + 1 < playfield.GridSize.Width) && playfield.GetCellAt(GetOffSet(1, 1)) == null);
				bool leftEmpty = ((offsetPos.x - 1 > 0) && playfield.GetCellAt(GetOffSet(-1, 1)) == null);
				if (randomNumber < 50)
				{
					if (leftEmpty)
					{
						mVel.Set(-1, 0); //MoveToOffset(-1, 0, playfield);
					}
					else if (rightEmpty)
					{
						mVel.Set(1, 0); //MoveToOffset(1, 0, playfield);
					}
				}
				else if(randomNumber < 90)
				{
					if (rightEmpty)
					{
						mVel.Set(1, 0); //MoveToOffset(1, 0, playfield);
					}
					else if (leftEmpty)
					{
						mVel.Set(-1, 0); //MoveToOffset(-1, 0, playfield);
					}
				}
			} 
		}

		public virtual void GetMetaData(String buffer)
		{
			buffer.Append("ID: ");
			ID.ToString(buffer);
			buffer.Append(", Rc: ");
			mRemovalcost.ToString(buffer);
			buffer.Append(", Rem: ");
			mRemovable.ToString(buffer);
			buffer.Append(", Pc: ");
			mPlacecost.ToString(buffer);
			buffer.Append(", LC: ");
			mLifeCycle.ToString(buffer);
			buffer.Append(", NU: ");
			mNextUpdate.ToString(buffer);
			buffer.Append(", ST: ");
			mSleepTimer.ToString(buffer);
			/*buffer.Append(", P: ");
			mPos.ToString(buffer);*/
			buffer.Append(", MD: ");
			mMarkDelete.ToString(buffer);
			buffer.Append(", HG: ");
			mHasGravity.ToString(buffer);
			/*buffer.Append(", Vel: ");
			mVel.ToString(buffer);*/

		}
	}
}