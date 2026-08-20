#include "stdafx.h"
#include "ioApplication.h"

#define APPLICATION_NAME "LSOffline"
#define FULLSCREEN_STYLE (WS_POPUP | WS_CLIPCHILDREN)
#define WINDOW_STYLE (WS_OVERLAPPED | WS_CAPTION | WS_CLIPCHILDREN | WS_SYSMENU | WS_MINIMIZEBOX)

template<> ioApplication* Singleton< ioApplication >::ms_Singleton = 0;

static LRESULT CALLBACK WndProc( HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam )
{
	return g_App.MsgProc( hWnd, uMsg, wParam, lParam );
}

ioApplication::ioApplication()
{
	m_hInstance = NULL;
	m_hWnd = NULL;
	m_iWidth = 0;
	m_iHeight = 0;
	m_iDeskTopWidth = 0;
	m_iDeskTopHeight = 0;
	m_pRenderSystem = NULL;
	m_pFrameTimer = NULL;
	m_bExit = false;
}

ioApplication::~ioApplication()
{
	ReleaseAll();
}

bool ioApplication::InitWindow( HINSTANCE hInstance )
{
	m_pFrameTimer = new ioFrameTimer;
	m_pFrameTimer->Start( 30.0f );

	m_iDeskTopWidth  = GetSystemMetrics( SM_CXSCREEN );
	m_iDeskTopHeight = GetSystemMetrics( SM_CYSCREEN );

	m_iWidth  = m_iDeskTopWidth;
	m_iHeight = m_iDeskTopHeight;

	WNDCLASS wc;
	wc.style			= CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
	wc.lpfnWndProc		= WndProc;
	wc.cbClsExtra		= 0;
	wc.cbWndExtra		= 0;
	wc.hInstance		= hInstance;
	wc.hIcon			= LoadIcon( hInstance, MAKEINTRESOURCE(IDR_MAINFRAME) );
	wc.hCursor			= LoadCursor( NULL, IDC_ARROW );
	wc.hbrBackground		= (HBRUSH)GetStockObject( BLACK_BRUSH );
	wc.lpszMenuName		= NULL;
	wc.lpszClassName		= APPLICATION_NAME;

	RegisterClass( &wc );

	HWND hWnd = CreateWindowEx( 0,
		APPLICATION_NAME,
		APPLICATION_NAME,
		FULLSCREEN_STYLE,
		0, 0, 0, 0,
		NULL,
		NULL,
		hInstance,
		NULL );

	if( !hWnd )
		return false;

	m_hWnd = hWnd;
	m_hInstance = hInstance;

	ShowWindow( hWnd, SW_SHOW );
	SetForegroundWindow( hWnd );
	SetFocus( hWnd );

	return true;
}

bool ioApplication::Setup()
{
	m_pRenderSystem = &RenderSystem();
	m_pRenderSystem->SetMinDisplayMode( 800, 600 );

	bool bWindowed = true;
	bool bCreateOK = m_pRenderSystem->Create( m_hWnd,
		m_iWidth,
		m_iHeight,
		false,
		bWindowed,
		false );

	if( !bCreateOK )
	{
		LOG.PrintTimeAndLog( 0, "ioApplication::Setup - RenderSystem Create Failed" );
		return false;
	}

	LOG.PrintTimeAndLog( 0, "ioApplication::Setup - RenderSystem Create OK (%dx%d)", m_iWidth, m_iHeight );
	return true;
}

void ioApplication::MainLoop()
{
	RenderLoop();
}

void ioApplication::RenderLoop()
{
	if( !m_pRenderSystem )
		return;

	if( !m_pRenderSystem->CheckLostDevice() )
		return;

	DWORD dwClearFlags = D3DCLEAR_TARGET | D3DCLEAR_ZBUFFER;
	m_pRenderSystem->ClearBack( dwClearFlags, D3DCOLOR_XRGB(30, 30, 60), NULL );

	if( m_pRenderSystem->BeginScene() )
	{
		m_pRenderSystem->EndScene();
	}

	m_pRenderSystem->Present();
}

int ioApplication::Run()
{
	MSG msg;

	while( TRUE )
	{
		if( PeekMessage( &msg, NULL, 0, 0, PM_NOREMOVE ) )
		{
			if( !GetMessage( &msg, NULL, 0, 0 ) )
				break;

			TranslateMessage( &msg );
			DispatchMessage( &msg );
			continue;
		}
		else
		{
			if( m_bExit )
			{
				DestroyWindow( m_hWnd );
			}
			else
			{
				MainLoop();
			}
		}
	}

	return (int)msg.wParam;
}

void ioApplication::ReleaseAll()
{
	LOG.PrintTimeAndLog( 0, "ioApplication::ReleaseAll - Start" );

	ReleaseRenderSystem();

	SAFEDELETE( m_pFrameTimer );

	LOG.PrintTimeAndLog( 0, "ioApplication::ReleaseAll - Done" );
}

LRESULT ioApplication::MsgProc( HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam )
{
	switch( uMsg )
	{
	case WM_KEYDOWN:
		if( wParam == VK_ESCAPE )
		{
			m_bExit = true;
			return 0;
		}
		break;

	case WM_CLOSE:
		m_bExit = true;
		return 0;

	case WM_DESTROY:
		PostQuitMessage( 0 );
		return 0;

	case WM_SIZE:
		if( wParam == SIZE_MINIMIZED )
			return 0;
		break;
	}

	return DefWindowProc( hWnd, uMsg, wParam, lParam );
}

ioApplication& ioApplication::GetSingleton()
{
	return *ms_Singleton;
}
