#include "stdafx.h"
#include "ioApplication.h"

int WINAPI WinMain( HINSTANCE hInstance,
				   HINSTANCE hPrevInstance,
				   LPSTR lpCmdLine,
				   int nShowCmd )
{
	LOG.OpenLog( 0, "info/pp.log" );
	LOG.PrintTimeAndLog( 0, "[Main] - LSOffline Start" );

	ioCPU::Init();

	timeBeginPeriod( 1 );
	ioFrameTimer::SetWindowsModule( true );

	ioApplication *pApp = new ioApplication;
	if( !pApp )
	{
		LOG.PrintTimeAndLog( 0, "[Main] - Create App Error!" );
		MessageBox( NULL, "Create App Error!", "LSOffline", MB_OK );
		return 0;
	}

	int iRet = -1;

	if( pApp->InitWindow( hInstance ) )
	{
		LOG.PrintTimeAndLog( 0, "[Main] - InitWindow Complete" );

		if( pApp->Setup() )
		{
			LOG.PrintTimeAndLog( 0, "[Main] - Setup Complete" );
			iRet = pApp->Run();
		}
		else
		{
			LOG.PrintTimeAndLog( 0, "[Main] - Setup Failed" );
			MessageBox( NULL, "RenderSystem Create Failed!", "LSOffline", MB_OK );
		}
	}
	else
	{
		LOG.PrintTimeAndLog( 0, "[Main] - InitWindow Failed" );
		MessageBox( NULL, "InitWindow Failed!", "LSOffline", MB_OK );
	}

	SAFEDELETE( pApp );

	ioResourceLoader::ReleaseInstance();
	ioCPU::ShotDown();

	LOG.PrintTimeAndLog( 0, "[Main] - LSOffline Exit" );
	LOG.CloseAndRelease();

	timeEndPeriod( 1 );

	return iRet;
}
