#pragma once

class ioRenderSystem;
class ioFrameTimer;

class ioApplication : public Singleton< ioApplication >
{
protected:
	HINSTANCE		m_hInstance;
	HWND			m_hWnd;
	int				m_iWidth;
	int				m_iHeight;
	int				m_iDeskTopWidth;
	int				m_iDeskTopHeight;

	ioRenderSystem  *m_pRenderSystem;
	ioFrameTimer    *m_pFrameTimer;

	bool			m_bExit;

public:
	ioApplication();
	virtual ~ioApplication();

	bool InitWindow( HINSTANCE hInstance );
	bool Setup();
	int  Run();
	void ReleaseAll();

	inline HWND GetHWnd() const { return m_hWnd; }
	inline HINSTANCE GetInstance() const { return m_hInstance; }
	inline bool IsExit() const { return m_bExit; }

protected:
	void MainLoop();
	void RenderLoop();

public:
	LRESULT MsgProc( HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam );

	static ioApplication& GetSingleton();
};

#define g_App ioApplication::GetSingleton()
