package com.dynamic.charm.io;

import java.io.File;
import java.util.Timer;

public class FileWatcher
{
	private File file;

	private long interval;

	private Timer timer;

	private long lastModified;

	public FileWatcher(File fileToWatch, long interval)
	{
		this.file = fileToWatch;
		this.interval = interval;
	}
	
//	public void addFileWatchListener(FileWatchListener fwl)
//	{
//		listeners.add(fwl);
//	}
//	
//	public void removeFileWatchListener(FileWatchListener fwl)
//	{
//		
//	}
//	
//	public void fireFileModified
//	{
//		
//	}
//	
//	public void start()
//	{
//		timer = new Timer("FileWatcher", true);
//		TimerTask task = new TimerTask()
//		{
//
//			public void run()
//			{
//				if (file.lastModified() > lastModified)
//				{
//					fireFileModified();
//				}
//				lastModified = file.lastModified();
//			}
//		};
//
//		timer.schedule(task, interval);
//	}
//
//	public synchronized void stop()
//	{
//		timer.cancel();
//	}

}
