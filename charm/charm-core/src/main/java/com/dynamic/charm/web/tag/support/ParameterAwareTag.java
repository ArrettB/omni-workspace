/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: ParameterAwareTag.java 199 2006-11-14 23:38:41Z gcase $

 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.web.tag.support;

import java.util.Iterator;

import javax.servlet.jsp.JspException;

import org.apache.log4j.Logger;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class ParameterAwareTag extends QueryServiceAwareTag implements ParamParent
{
    private static final Logger logger = Logger.getLogger(ParameterAwareTag.class);
    private ParamHelper _paramHelper;

    public ParameterAwareTag()
    {
        super();
        logger.info("ParameterAwareTag()");
    }

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
    }

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");

        // must clear out any parameters from previous invocations
        if (_paramHelper != null)
        {
            _paramHelper.release();
        }
        _paramHelper = new ParamHelper();
        return EVAL_BODY_INCLUDE;
    }

    public void release()
    {
        logger.debug("release()");
        super.release();
        if (_paramHelper != null)
        {
            _paramHelper.release();
        }
        _paramHelper = null;
    }

    public void addParameter(String name, Object value)
    {
        logger.debug("Adding parameter:" + name + " = " + value);
        _paramHelper.addParameter(name, value);
    }

    public Iterator getParameterNames()
    {
        return _paramHelper.getParameterNames();
    }

    public Object getParameterValue(String name)
    {
        return _paramHelper.getParameterValue(name);
    }

    public Object[] paramsToValueArray()
    {
        return _paramHelper.toValueArray();
    }

    public String[] paramsToNameArray()
    {
        return _paramHelper.toNameArray();
    }

    public int[] paramsToTypeArray()
    {
        return _paramHelper.toTypeArray();
    }

    public int getNumberParameters()
    {
        return _paramHelper.getNumberParameters();
    }
}
