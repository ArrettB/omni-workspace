/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AbstractParameterAwareFieldTag.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag;

import java.util.Iterator;

import org.apache.log4j.Logger;

import com.dynamic.charm.web.tag.support.ParamHelper;
import com.dynamic.charm.web.tag.support.ParamParent;


public abstract class AbstractParameterAwareFieldTag extends AbstractFieldTag implements ParamParent
{
    private final static Logger logger = Logger.getLogger(AbstractParameterAwareFieldTag.class);
    private ParamHelper paramHelper;

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");
        super.doStartTagInternal();

        // must clear out any parameters from previous invocations
        if (paramHelper != null)
        {
            paramHelper.release();
        }
        paramHelper = new ParamHelper();
        return EVAL_BODY_INCLUDE;
    }

    public void release()
    {
        logger.debug("release()");
        super.release();
        if (paramHelper != null)
        {
            paramHelper.release();
        }
        paramHelper = null;
    }

    public void addParameter(String name, Object value)
    {
        logger.debug("Adding parameter:" + name + " = " + value);
        paramHelper.addParameter(name, value);
    }

    public Iterator getParameterNames()
    {
        return paramHelper.getParameterNames();
    }

    public Object getParameterValue(String name)
    {
        return paramHelper.getParameterValue(name);
    }

    public Object[] paramsToValueArray()
    {
        return paramHelper.toValueArray();
    }

    public String[] paramsToNameArray()
    {
        return paramHelper.toNameArray();
    }

    public int[] paramsToTypeArray()
    {
        return paramHelper.toTypeArray();
    }

    public int getNumberParameters()
    {
        return paramHelper.getNumberParameters();
    }
}
