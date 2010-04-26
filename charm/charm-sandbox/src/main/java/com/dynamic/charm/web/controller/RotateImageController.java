package com.dynamic.charm.web.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.ModelAndView;

public class RotateImageController extends BaseController
{

	private String path;
	
	private Random random = new Random(System.currentTimeMillis());
	private static final String[] extensions = {"gif", "jpg", "jpeg", "png"};

	public void afterPropertiesSetInternal()
	{
	}

	public void registerRequiredProperties()
	{
		registerRequiredProperty("path");
	}

	
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		File directory = new File(path);
		Collection files = FileUtils.listFiles(directory, extensions, true);
		List fileList = new ArrayList(files);
		
		int index = random.nextInt(fileList.size());
		File file = (File) fileList.get(index);
		String mimeType = getServletContext().getMimeType(file.getPath());
		response.setHeader("Content-disposition", "inline;filename=\"" + file.getPath()+"\"");
		response.setContentType(mimeType);
		response.setContentLength((int) file.length());
		FileCopyUtils.copy(new BufferedInputStream(new FileInputStream(file)), response.getOutputStream());
		
		return null;
	}

}

