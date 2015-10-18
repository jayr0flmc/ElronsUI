local Engine = getglobal('ElronsUI')
local Config = Engine:NewModule('Config')
local DB = Engine.DB



function Config:Initialize()
	DB:RegisterDB('ElronsDB', 'ElronsCharacterDB')
	
	DB:RegisterDefaults('profile', {
		general = {
			firstLaunch = true,
			uiScale = 0.75,
			
			userSettings = {
				uiScale		= 1.0,
				useUiScale	= 0
			},
			
			
			
			class = {
				texture = 'Interface\\Glues\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES',
				dimension = {
					icon	= 64,
					texture	= 256
				},
				columns	= 4,
				rows	= 4,
				
				druid = {
					color	= {r = 1.00, g = 0.49, b = 0.04},
					role	= {tank = true, heal = true, dps = true}
				},
				hunter = {
					color	= {r = 0.67, g = 0.83, b = 0.45},
					role	= {tank = false, heal = false, dps = true}
				},
				mage = {
					color	= {r = 0.47, g = 0.80, b = 0.94},
					role	= {tank = false, heal = false, dps = true}
				},
				paladin = {
					color	= {r = 0.96, g = 0.55, b = 0.73},
					role	= {tank = true, heal = true, dps = true}
				},
				priest = {
					color	= {r = 1.00, g = 1.00, b = 1.00},
					role	= {tank = false, heal = true, dps = true}
				},
				rogue = {
					color	= {r = 1.00, g = 0.96, b = 0.41},
					role	= {tank = false, heal = false, dps = true}
				},
				shaman = {
					color	= {r = 0.96, g = 0.55, b = 0.73},
					role	= {tank = false, heal = true, dps = true}
				},
				warlock = {
					color	= {r = 0.58, g = 0.51, b = 0.79},
					role	= {tank = false, heal = false, dps = true}
				},
				warrior = {
					color	= {r = 0.78, g = 0.61, b = 0.43},
					role	= {tank = true, heal = false, dps = true}
				}
			},
			
			development	= true,
			debug		= false
		},
		
		modules = {
			enabled = {
				'UnitFrames'
			}
		},
		
		layout = {
			window = {
				backdrop = {
					bgFile		= 'Interface\\AddOns\\ElronsUI\\textures\\backdrop_plain.tga',
					edgeFile	= 'Interface\\AddOns\\ElronsUI\\textures\\backdrop_plain.tga',
					tile		= false,
					tileSize	= 0,
					edgeSize	= 1,
					insets = {
						left	= -2,
						right	= -2,
						top		= -2,
						bottom	= -2
					},
					
					color = {
						r	= 0.1,
						g	= 0.1,
						b	= 0.1,
						a	= 1.0
					}
				},
				border = {
					color = {
						r	= 0.3,
						g	= 0.3,
						b	= 0.3,
						a	= 1.0
					}
				}
			},
			
			button = {
				backdrop = {
					bgFile		= 'Interface\\AddOns\\ElronsUI\\textures\\backdrop_plain.tga',
					edgeFile	= 'Interface\\AddOns\\ElronsUI\\textures\\backdrop_plain.tga',
					tile		= false,
					tileSize	= 0,
					edgeSize	= 1,
					insets = {
						left	= -2,
						right	= -2,
						top		= -2,
						bottom	= -2
					},
					
					color = {
						r	= 0.1,
						g	= 0.1,
						b	= 0.1,
						a	= 1.0
					}
				},
				border = {
					color = {
						r	= 0.3,
						g	= 0.3,
						b	= 0.3,
						a	= 1.0
					}
				}
			},
			
			statusbar = {
				backdrop = {
					bgFile		= 'Interface\\AddOns\\ElronsUI\\textures\\bars\\bar_5.tga',
					edgeFile	= 'Interface\\AddOns\\ElronsUI\\textures\\backdrop_plain.tga',
					tile		= false,
					tileSize	= 0,
					edgeSize	= 1,
					insets = {
						left	= -1,
						right	= -1,
						top		= -1,
						bottom	= -1
					},
					
					color = {
						r	= 1.0,
						g	= 1.0,
						b	= 1.0,
						a	= 0.25
					}
				},
				border = {
					color = {
						r	= 0.0,
						g	= 0.0,
						b	= 0.0,
						a	= 0.0
					}
				}
			}
		},
		
		
		
		chat = {
			width			= 412,
			height			= 200,
			font			= 'ChatFontNormal',
			size			= 10,
			justifyH		= 'LEFT',
			historyMaxLines	= 128,
			
			interval = {
				throttle	= 45,
				scrollDown	= 15
			},
			
			editBox = {
				height		= 20,
				font		= 'ChatFontNormal',
				size		= 10,
				justifyH	= 'LEFT',
				position	= 'TOP',
				
				color = {
					r	= 1.0,
					g	= 1.0,
					b	= 1.0,
					a	= 1.0
				}
			}
		},
		
		unitframe = {
			width	= 270,
			height	= 54,
			
			player = {
				buffs = {
					min	= 6,
					max	= 12
				},
				debuffs = {
					min	= 8,
					max	= 8
				}
			},
			
			target = {
				buffs = {
					min	= 6,
					max	= 12
				},
				debuffs = {
					min	= 8,
					max	= 8
				}
			},
			
			pet = {
				buffs = {
					min	= 6,
					max	= 12
				},
				debuffs = {
					min	= 8,
					max	= 8
				}
			}
		},
		
		
		
		debug = {
			info	= true,
			debug	= true,
			warn	= true,
			error	= true,
			crit	= true
		}
	})
	
	
	
	-- Create configuration window
	self:CreateConfigWindow()
	
	return true
end