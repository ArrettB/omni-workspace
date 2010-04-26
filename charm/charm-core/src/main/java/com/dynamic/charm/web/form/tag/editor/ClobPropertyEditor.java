package com.dynamic.charm.web.form.tag.editor;

import java.beans.PropertyEditorSupport;
import java.sql.Clob;

import org.apache.log4j.Logger;
import org.hibernate.lob.ClobImpl;

import com.dynamic.charm.query.jdbc.JDBCUtils;

public class ClobPropertyEditor extends PropertyEditorSupport
{
	private final static Logger logger = Logger.getLogger(ClobPropertyEditor.class);
	
	public ClobPropertyEditor()
	{
		logger.debug("ClobPropertyEditor()");
	}
	
	public String getAsText()
	{
		logger.debug("getAsText()");
		Clob clob = (Clob) getValue();
        return JDBCUtils.clobToString(clob);
	}
	
	public void setAsText(String text) throws IllegalArgumentException
	{
		logger.debug("setAsText() - " + text);
		setValue(new ClobImpl(text));
	}
	
	
}
