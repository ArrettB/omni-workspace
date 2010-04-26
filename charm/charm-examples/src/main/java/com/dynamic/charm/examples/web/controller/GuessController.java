package com.dynamic.charm.examples.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.math.RandomUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.dynamic.charm.web.controller.BaseController;

public class GuessController extends BaseController implements Controller
{
	private int min = 1;
	private int max = 100;
	private String successView;
	private String formView;
	
	private final static String SESSION_ANSWER_NAME= GuessController.class.getName() + ".answer";
	
	public void afterPropertiesSetInternal()
	{
	}

	public void registerRequiredProperties()
	{
		registerRequiredProperty("successView");
	}
	
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse resp) throws Exception
	{
		Integer guess = getIntegerParameter(req, "guess");
	
		if (guess == null)
		{
			String errorMessage = "You must supply a guess";
			ModelAndView result = new ModelAndView(formView);
			result.addObject("message", errorMessage);
			return result;
		}
		else
		{
			Integer answer = retrieveAnswer(req);
			int compare = guess.compareTo(answer);
			if (compare == 0)
			{
				ModelAndView result = new ModelAndView(successView);
				removeSessionAttribute(req, SESSION_ANSWER_NAME);
				return result;
			}
			else if (compare < 0)
			{
				return new ModelAndView(formView, "message", "Too Low!");
			}
			else
			{
				return new ModelAndView(formView, "message", "Too High!");
			}
		}
		
		
	}

	
	private Integer retrieveAnswer(HttpServletRequest req)
	{
		Integer answer = (Integer) getSessionAttribute(req, SESSION_ANSWER_NAME);
		if (answer ==null)
		{
			answer = new Integer( RandomUtils.nextInt(max-min) + min);
			setSessionAttribute(req, SESSION_ANSWER_NAME, answer);
		}
		return answer;
	}

	public int getMax()
	{
		return max;
	}

	public void setMax(int max)
	{
		this.max = max;
	}

	public int getMin()
	{
		return min;
	}

	public void setMin(int min)
	{
		this.min = min;
	}

	public String getSuccessView()
	{
		return successView;
	}

	public void setSuccessView(String successView)
	{
		this.successView = successView;
	}

	public String getFormView()
	{
		return formView;
	}

	public void setFormView(String formView)
	{
		this.formView = formView;
	}



}
