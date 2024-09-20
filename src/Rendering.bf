using BasicEngine.GameStates;
using BasicEngine;
//using BasicEngine.ANN;
using System;
using BasicEngine.LayeredList;
using System.Collections;
using BasicEngine.Debug;
using BasicEngine.Collections;
using BasicEngine.Rendering;
using BasicEngine.Entity;
using CelluarAutomaton.Entity;
using SDL2;
using System.Threading;
using BasicEngine.HUD;
using CelluarAutomaton.Entity.Cell;
using CelluarAutomaton.Entity.Cell.Brains;
namespace CelluarAutomaton
{
	class Rendering : GameState
	{
		//private List<FractelChunkMultiThread> fcList = new List<FractelChunkMultiThread>() ~ DeleteContainerAndItems!(_);
		private CelluarAutomatonObj automaton = null ~ SafeDelete!(_);
		//private FractelChunk fc = null ~ SafeDelete!(_);
		private uint64 money = 1000000;
		bool mLiveUpdate = false;

		List<DataLabel<int64>> timerLabels = new List<DataLabel<int64>>() ~ DeleteContainerAndItems!(_);
		DataLabel<uint64> moneyLabel = null ~ DeleteAndNullify!(_);
		DataLabel<int> toPlaceCellLabel = null ~ DeleteAndNullify!(_);
		Label cellInspect = null ~ DeleteAndNullify!(_);

		bool lastStatus = false;
		Image lastStatusString = null ~ SafeDelete!(_);

		public this()
		{
			//automaton = new CelluarAutomatonObj(new .(gGameApp.mScreen.w, gGameApp.mScreen.h));

			gGameApp.mCam.mScale = 4.4f;
			gGameApp.mCam.[Friend]_resetScale = gGameApp.mCam.mScale;

			Vector2D camPos = new Vector2D(-145, 0); //-350
			delete gGameApp.mCam.mPos;
			delete gGameApp.mCam.[Friend]_resetPoint;
			gGameApp.mCam.mPos = camPos;
			gGameApp.mCam.[Friend]_resetPoint = new Vector2D(camPos);

			automaton = new CelluarAutomatonObj(new .(512, 512));

			GenLevel();
			for (var i in 0 ..< 1)
			{
				/*var cell = new Cell(0, 255, 0);
				//cell.SetGridPos(gGameApp.mRand.Next(0,gGameApp.mScreen.w),gGameApp.mRand.Next(0,gGameApp.mScreen.h));
				cell.SetBrain(new Tree());
				automaton.AddCellAt(cell, .(gGameApp.mScreen.w / 4, gGameApp.mScreen.h / 4));
				automaton.CopyCellTo(cell, .(gGameApp.mScreen.w / 2, gGameApp.mScreen.h / 4));
				automaton.CopyCellTo(cell, .(gGameApp.mScreen.w / 4, gGameApp.mScreen.h / 2));
				automaton.CopyCellTo(cell, .(gGameApp.mScreen.w / 2, gGameApp.mScreen.h / 2));*/
			}

			/*for (var x in 0 ... 255)
			{
				for (var y in 0 ... 255)
				{
					if (x % 4 == 0 && y % 4 == 0)
					{
						var cell = new Cell(0, 255, 0);
						cell.SetGridPos(x, y);
						automaton.lCells.Add(cell);
					}
				}
			}*/
			/*fc.[Friend]xMax = 1;
			fc.[Friend]yMax = 1;
			fc.[Friend]xMin = -1;
			fc.[Friend]yMin = -1;*/

			/*fc.[Friend]xMax = gGameApp.mScreen.w;//1;
			fc.[Friend]yMax = gGameApp.mScreen.h;
			fc.[Friend]xMin = 0;
			fc.[Friend]yMin = 0;*/
			//fc = new FractelChunk(new .(gGameApp.mScreen.w * 2, gGameApp.mScreen.h * 2), -2, 2, -2, 2, 2, 400);

			var label = new DataLabel<int64>(&(automaton.[Friend]lastRenderingTime), 4, 4 + (28 * (0 + 1)));
			timerLabels.Add(label);
			/*
			timerLabels.Add(new DataLabel<int64>(&fc.LastRenderingTimes[1], 4, 4 + (28 * 1)));
			timerLabels.Add(new DataLabel<int64>(&fc.LastRenderingTimes[3], 4, 4 + (28 * 2)));
			timerLabels.Add(new DataLabel<int64>(&fc.LastRenderingTimes[5], 4, 4 + (28 * 3)));*/

			label.AutoUpdate = false;
			label.UpdateString(0, true);

			toPlaceCellLabel = new DataLabel<int>(null, 4, 4 + (28 * (1 + 1)));
			toPlaceCellLabel.[Friend]mformatString = "Cells: {}";

			moneyLabel = new DataLabel<uint64>(null, 4, 4 + (28 * (2 + 1)));
			moneyLabel.[Friend]mformatString = "Money: {}";

			cellInspect = new Label("", 4, 4 + (28 * (3 + 1)));

			automaton.RenderImage();
			let buff = new String();
			CellFactory.IDtoString(toPlaceType, buff);
			toPlaceCellLabel.SetString(buff); /*for (var fc in fc)
			{
				Logger.Debug(StackStringFormat!("{} / {}", (++cnt), fc.Count));
				fc.PreperRenderImages();
			}*/
			//RenderAsVideo();
		}

		public ~this()
		{
		}

		private void setUpHud()
		{
		}

		public char8* lastError;
		public override void Draw(int dt)
		{
			//base.Draw(dt);

			/*SDL.SetRenderDrawColor(gEngineApp.mRenderer, 127, 127, 78, 255);
			SDL.RenderFillRect(gGameApp.mRenderer, &gGameApp.mScreen.clip_rect);
			SDL.SetRenderDrawColor(gEngineApp.mRenderer, 0, 0, 0, 255);*/

			automaton.Draw();
			/*for (var i in ..<timerLabels.Count)
			{
				var label = timerLabels[i];
				label.Draw(dt);
				//if (label.[Friend]mLastStringValue != fc.LastRenderingTimes[i])
			}*/

			for (var label in timerLabels)
			{
				label.Draw(dt);
			}
			toPlaceCellLabel.Draw(dt);
			moneyLabel.Draw(dt);
			cellInspect.Draw(dt);
			if (lastError != SDL.GetError())
			{
				lastError = SDL.GetError();
				if (*lastError != (char8)0)
				{
					Logger.Error(scope String(lastError));
				}
			}
		}

		public override void Update(int dt)
		{
			base.Update(dt);
			//statusLabel.UpdateString(automaton.lCells.Count, true);
			for (var i in ..<timerLabels.Count)
			{
				var label = timerLabels[i];
				{
					if (label.UpdateString())
					{
						var str = new System.String();
						str.AppendF("{} : {}", i + 1,
							TimeSpan((int64) * label.[Friend]mPointer));

						label.SetString(str);
					}
					label.mVisiable = true;
				}
			}
			automaton.AddHighlightedCell(.(lastMousePos));
			automaton.Update();
			automaton.RenderImage();

			moneyLabel.UpdateString(money, true);
		}

		Vector2D lastMousePos = new Vector2D(0, 0) ~ SafeDelete!(_);
		//v2d<float> lastClickUpdated = v2d<float>(0, 0);
		CellTypes toPlaceType = .Sand;
		//bool holdingMouseDown = false;
		public override void MouseDown(SDL2.SDL.MouseButtonEvent evt)
		{
			base.MouseDown(evt);

			for (let entity in gEngineApp.mEntityList.mLayers[(int)LayeredList.LayerNames.HUD].mEntities)
			{
				if (let button = entity as BasicEngine.HUD.Button)
				{
					if ((button.mBoundingBox.Contains((.)(evt.x - entity.mPos.mX), (.)(evt.y - entity.mPos.mY))) && (button.mEnabled && button.mVisiable))
					{
						button.onClick();
					}
				}
			}
		}

		public override void MouseUp(SDL2.SDL.MouseButtonEvent evt)
		{
			base.MouseUp(evt);
		}

		int delay = 0;
		public override void HandleInput()
		{
			double lastY = lastMousePos.mY;
			double lastX = lastMousePos.mX;
			uint32 MouseButton = UpdateMousePos();

			var selCell = automaton.GetCellAt(.((int)lastMousePos.mX, (int)lastMousePos.mY));
			if (selCell != null)
			{
				let selCellMeta = new String();
				selCell.GetMetaData(selCellMeta);
				cellInspect.SetString(selCellMeta);
			}
			if (MouseButton > 0)
			{
				bool LButton = MouseButton == SDL.BUTTON_LMASK;
				bool RButton = MouseButton == SDL.BUTTON_RMASK;
				bool MButton = MouseButton == SDL.BUTTON_MMASK;

				double y = lastMousePos.mY;
				double x = lastMousePos.mX;
				v2d<int> startPos = .((int)lastX, (int)lastY);
				v2d<int> endPos = .((int)x, (int)y);

				for (int i = 1; i <= 100; i++)
				{
					float pct = (float)i / 100;
					v2d<int> tPos = .((int)Math.Lerp(startPos.x, endPos.x, pct), (int)Math.Lerp(startPos.y, endPos.y, pct));
					var tCell = automaton.GetCellAt(tPos);
					if (tCell != null && automaton.[System.Friend]cellGridBuffer[tPos.y, tPos.x] == null)
					{
						if (RButton)
						{
							if (money >= tCell.mRemovalcost && tCell.mRemovable) //tCell.ID != .Shop
							{
								automaton.ClearCell(tPos);
								money -= tCell.mRemovalcost;
							}
						}
						else if (LButton)
						{
						}
						else if (MButton)
						{
							if (CellFactory.IsPlacable(tCell.ID))
								toPlaceType = tCell.ID;

							let buff = new String();
							CellFactory.IDtoString(toPlaceType, buff);
							toPlaceCellLabel.SetString(buff);
						}
					} else
					{
						if (RButton)
						{
						}
						else if (LButton)
						{
							Cell c = CellFactory.NewFromId(toPlaceType);
							if (automaton.[System.Friend]cellGridBuffer[tPos.y, tPos.x] == null && money >= c.mPlacecost)
							{
								automaton.AddCellAt(c, tPos);
								money -= c.mPlacecost;
							}
							else
								delete c;
						}
						else if (MButton)
						{
							toPlaceType = .Sand;
							let buff = new String();
							CellFactory.IDtoString(toPlaceType, buff);
							toPlaceCellLabel.SetString(buff);
						}
					}
					if (tPos == endPos)
						break;
				}
			}

			if (--delay > 0)
				return;
			/*Vector2D pos1 = scope .(x1,y1);
			Vector2D pos2 = scope .(x2,y2);
			var dirLen = ray.mDir.Length();
			var deltaX = ray.mDir.x / dirLen * stepSize;
			var deltaY = ray.mDir.y / dirLen * stepSize;*/

			var delta = 0.5f;
			if (gGameApp.IsKeyDown(.LShift))
				delta = 5;
			if (gGameApp.IsKeyDown(.KpMinus))
			{
				/*for (var fc in fc)
				{*/
				automaton.[Friend]zoomScale = automaton.[Friend]zoomScale / 1.25f; //Math.Max(fc.[Friend]zoomScale / 1.25f, 1);
				Logger.Info("zoom", automaton.[Friend]zoomScale);
				//}
				delay = 20;
			}
			else if (gGameApp.IsKeyDown(.KpPlus))
			{
				/*for (var fc in fc)
				{*/
				automaton.[Friend]zoomScale *= 1.25f;
				Logger.Info("zoom", automaton.[Friend]zoomScale);
				//}
				delay = 20;
			}


			if (gGameApp.IsKeyDown(.Space))
			{
				delay = 20;
				if (automaton.mPauseSimulation)
				{
					automaton.mPauseSimulation = false;
				} else
				{
					automaton.mPauseSimulation = true;
				}
			}

			if (gGameApp.IsKeyDown(.K))
			{
				/*for (var fc in fc)
				{*/
				/*fc.[Friend]yOffset -= (delta * 0.5) / fc.[Friend]zoomScale;
				Logger.Info("y", fc.[Friend]yOffset);*/
				//}
				delay = 20;
			}
			else if (gGameApp.IsKeyDown(.I))
			{
				/*for (var fc in fc)
				{*/
				/*fc.[Friend]yOffset += (delta * 0.5) / fc.[Friend]zoomScale;
				Logger.Info("y", fc.[Friend]yOffset);*/
				//}
				delay = 20;
			}

			if (gGameApp.IsKeyDown(.J))
			{
				/*for (var fc in fc)
				{*/
				/*fc.[Friend]xOffset -= (delta * 0.5) / fc.[Friend]zoomScale;
				Logger.Info("x", fc.[Friend]xOffset);*/
				//}
				repeat
				{
					toPlaceType = (CellTypes)((uint16)toPlaceType + 1);
					if (((uint16)toPlaceType) > 100)
						toPlaceType = (CellTypes)0;
				}
				while (!CellFactory.IsPlacable(toPlaceType));
				let buff = new String();
				CellFactory.IDtoString(toPlaceType, buff);
				toPlaceCellLabel.SetString(buff);
				//toPlaceCellLabel.UpdateString((int)toPlaceType, true);
				delay = 10;
			}
			else if (gGameApp.IsKeyDown(.L))
			{
				/*for (var fc in fc)
				{*/
				/*fc.[Friend]xOffset += (delta * 0.5) / fc.[Friend]zoomScale;
				Logger.Info("x", fc.[Friend]xOffset);*/
				//}
				repeat
				{
					if (((uint16)toPlaceType) == 0)
						toPlaceType = (CellTypes)100;
					else
						toPlaceType = (CellTypes)((uint16)toPlaceType - 1);
				}
				while (!CellFactory.IsPlacable(toPlaceType));
				let buff = new String();
				CellFactory.IDtoString(toPlaceType, buff);
				toPlaceCellLabel.SetString(buff);


				//toPlaceCellLabel.UpdateString((int)toPlaceType, true);

				delay = 10;
			}

			if (gGameApp.IsKeyDown(.N)) // Reset
			{
				/*for (var fc in fc)
				{*/
				/*fc.[Friend]xOffset = 0;
				fc.[Friend]yOffset = 0;
				fc.[Friend]zoomScale = 1;
				Logger.Info("reset", fc.[Friend]xOffset);*/
				//}
				delay = 20;
			}

			if (gGameApp.IsKeyDown(.Q))
			{
				/*for (var fc in fc)
				{*/
				//fc.[Friend]xyPixelStep = Math.Max(fc.[Friend]xyPixelStep - 1, 1);
				gGameApp.mCam.mScale = Math.Max(gGameApp.mCam.mScale - 0.1f, 1);
				Logger.Info("zoom", gGameApp.mCam.mScale);
				//}
				delay = 1;
			}
			else if (gGameApp.IsKeyDown(.E))
			{
				//for (var fc in fc)
				//{
				//fc.[Friend]xyPixelStep++;
				gGameApp.mCam.mScale += 0.1f;
				Logger.Info("zoom", gGameApp.mCam.mScale);
				//}
				delay = 1;
			}


			if (gGameApp.IsKeyDown(.U))
			{
				/*for (var fc in fc)
				{*/
				automaton.[Friend]xyPixelStep = Math.Max(automaton.[Friend]xyPixelStep - 1, 1);
				Logger.Info("xyPixelStep", automaton.[Friend]xyPixelStep);
				//}
				delay = 20;
			}
			else if (gGameApp.IsKeyDown(.O))
			{
				//for (var fc in fc)
				//{
				automaton.[Friend]xyPixelStep++;
				Logger.Info("xyPixelStep", automaton.[Friend]xyPixelStep);
				//}
				delay = 20;
			}

			if (gGameApp.IsKeyDown(.S))
			{
				gGameApp.mCam.mPos.mY -= delta;
			}
			else if (gGameApp.IsKeyDown(.W))
			{
				gGameApp.mCam.mPos.mY += delta;
			}

			if (gGameApp.IsKeyDown(.D))
			{
				gGameApp.mCam.mPos.mX -= delta;
			}
			else if (gGameApp.IsKeyDown(.A))
			{
				gGameApp.mCam.mPos.mX += delta;
			}


			/*if (gGameApp.IsKeyDown(.Kp1))
			{
				fc.mThreadEnabled[0] = !fc.mThreadEnabled[0];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp2))
			{
				fc.mThreadEnabled[1] = !fc.mThreadEnabled[1];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp3))
			{
				fc.mThreadEnabled[2] = !fc.mThreadEnabled[2];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp4))
			{
				fc.mThreadEnabled[3] = !fc.mThreadEnabled[3];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp5))
			{
				fc.mThreadEnabled[4] = !fc.mThreadEnabled[4];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp6))
			{
				fc.mThreadEnabled[5] = !fc.mThreadEnabled[5];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp7))
			{
				fc.mThreadEnabled[6] = !fc.mThreadEnabled[6];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp8))
			{
				fc.mThreadEnabled[7] = !fc.mThreadEnabled[7];
				delay = 21;
			} else if (gGameApp.IsKeyDown(.Kp9))
			{
				//fc.mThreadEnabled[8] = !fc.mThreadEnabled[8];
				delay = 21;
			}*/

			if (gGameApp.IsKeyDown(.R))
			{
				/*for (var fc in fc)
				{*/
				/*automaton.Update();
				automaton.RenderImage();*/
				//}
				GenLevel();
				delay = 20;
			}
			if (gGameApp.IsKeyDown(.B))
			{
				mLiveUpdate = !mLiveUpdate;
				Logger.Info("mLiveUpdate", mLiveUpdate);

				delay = 10;
			}
			if (gGameApp.IsKeyDown(.N))
			{
				mLiveUpdate = false;
				Logger.Info("mLiveUpdate", mLiveUpdate);

				delay = 10;
			}
			if (gGameApp.IsKeyDown(.M))
			{
				gGameApp.mCam.Reset();
			}

			if (delay == 20)
			{
				if (mLiveUpdate)
				{
					automaton.RenderImage();
				}
			}
		}

		void GenLevel()
		{
			v2d<int> halfPos = .((int)automaton.[Friend]mSize.mX / 2, (int)automaton.[Friend]mSize.mY - 1);

			for (int y = (int)automaton.[Friend]mSize.mY - 1; y >= 0; y--)
			{
				for (int x = (int)automaton.[Friend]mSize.mX - 1; x >= 0; x--)
				{
					v2d<int> pos = .(x, y);
					if (pos.y < 9 || pos.x < 9 || pos.y >= (int)automaton.[Friend]mSize.mY - 9 || pos.x >= (int)automaton.[Friend]mSize.mX - 9)
					{
						Cell cell = new Unobstonium(pos);
						if (x > 20 && pos.y < 29 && pos.y > 25)
						{
							delete cell;
							cell = new Shop(pos);
						}
						automaton.AddCellAt(cell, pos);
						continue;
					}

					if ((y < 30 && y > 15) && x > (halfPos.x))
						continue;
					Cell cell = new Stone(pos);
					if(gGameApp.mRand.GetChance(0.1) && gGameApp.mRand.GetChance(0.1))
					{
						delete cell;
						cell = new Ore(pos);
					}
					automaton.AddCellAt(cell, pos);
				}
			}

			int minTries = 150;
			int maxTries = (int)(gGameApp.mRand.Next(minTries, minTries+25));
			for (var tries = 0; tries < maxTries; tries++)
			{
				v2d<int> startPos = .(gGameApp.mRand.Next(0, 512), gGameApp.mRand.Next(0, 512));
				v2d<int> startPosOffset = .(0, 0);
				v2d<int> tPos = .(0, 0);
				int startRadi = (int)(gGameApp.mRand.Next(2, 10));
				int radi = startRadi;
				SDL2.SDL.Color oreColor = .(0, 0, 0, 255);
				oreColor.b = (uint8)(gGameApp.mRand.NextDouble() * 0xff);
				oreColor.r = (uint8)(gGameApp.mRand.NextDouble() * 0xff);
				oreColor.g = (uint8)(gGameApp.mRand.NextDouble() * 0xff);
				bool placeAdd = true;
				while (placeAdd)
				{
					startPosOffset.x = (int)(gGameApp.mRand.Next(0, (startRadi)+1)) - (startRadi/2); 
					startPosOffset.y = (int)(gGameApp.mRand.Next(0, startRadi+1))- (startRadi/2); 
					radi = (int)(gGameApp.mRand.Next(2, startRadi));
					for (var yOffSet = -radi; yOffSet <= radi; yOffSet++)
					{
						for (var xOffSet = -radi; xOffSet <= radi; xOffSet++)
						{
							var actualRadi = Math.Sqrt(Math.Abs(xOffSet * xOffSet) + Math.Abs(yOffSet * yOffSet));
							if (radi < actualRadi)
								continue;

							tPos.Set(startPos.x + xOffSet + startPosOffset.x, startPos.y + yOffSet + startPosOffset.y);
							if (tPos.x >= 9 + radi && tPos.y >= 9 + radi && tPos.x < automaton.[Friend]GridSize.Width - (9 + radi) && tPos.y < automaton.[Friend]GridSize.Height - (9 + radi))
							{
								var curCell = automaton.GetCellAt(tPos);

								automaton.ClearCell(tPos);
								Cell cell = new Ore(tPos);
								cell.mColor = oreColor;
								automaton.AddCellAt(cell, tPos);
							}
						}
					}
					
					if (gGameApp.mRand.GetChance(0.1))
						placeAdd = false;
				}
			}

			for (int yOffSet = (int)automaton.[Friend]mSize.mY - 1; yOffSet > 0; yOffSet--)
			{
				for (int xOffSet = (int)automaton.[Friend]mSize.mX - 1; xOffSet > 0; xOffSet--)
				{
					v2d<int> pos = .(xOffSet, yOffSet);
					if (!((yOffSet < (int)automaton.[Friend]mSize.mY) && (xOffSet < (int)automaton.[Friend]mSize.mX) && yOffSet >= 0 && xOffSet >= 0))
					{
						continue;
					}
					if (pos.y < 9 || pos.x < 9 || pos.y > (int)automaton.[Friend]mSize.mY - 9 || pos.x > (int)automaton.[Friend]mSize.mX - 9)
					{
						continue;
					}

					if (pos.y == 31 || pos.y == 30)
					{
						if (pos.x < (halfPos.x) && pos.x >= 9)
						{
							//delete cell;
							//cell = new ConveyorR(pos);
						}
						else if (pos.x > (halfPos.x) && pos.x <= (int)automaton.[Friend]mSize.mX - 9)
						{
							automaton.ClearCell(pos);
							Cell cell = new ConveyorR(pos);
							automaton.AddCellAt(cell, pos);
						}
					}
					/*else if(pos.y > 512-7)
					{
						Cell cell = new Unobstonium(pos);
						automaton.AddCellAt(cell, pos);
					}*/
				}
			}
		}

		uint32 UpdateMousePos()
		{
			int32 mouseX = 0;
			int32 mouseY = 0;
			uint32 button = SDL.GetMouseState(&mouseX, &mouseY);
			float EndxIndex = (mouseX) / gGameApp.mCam.mScale - gGameApp.mCam.mPos.mX;
			float EndyIndex = (mouseY) / gGameApp.mCam.mScale - gGameApp.mCam.mPos.mY;
			EndxIndex = Math.Max(Math.Min((EndxIndex), 511), 0);
			EndyIndex = Math.Max(Math.Min((EndyIndex - 1), 511), 0);
			lastMousePos.Set(EndxIndex, EndyIndex);
			return button;
		}
	}
}
