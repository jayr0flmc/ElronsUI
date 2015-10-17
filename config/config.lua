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
			
			development	= true,
			debug		= false
		},
		
		modules = {
			enabled = {
				
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
		
		
		
		debug = {
			info	= true,
			debug	= false,
			warn	= true,
			error	= true,
			crit	= true
		}
	})
	
	
	
	-- Create configuration window
	self:CreateConfigWindow()
	
	return true
end