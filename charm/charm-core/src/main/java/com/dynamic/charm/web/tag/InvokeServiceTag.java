/*
 *               Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written
 * consent of Dynamic Information Systems. All rights reserved.

 * Copyright 2005, Dynamic Information Systems, LLC
 * $Id: InvokeServiceTag.java 375 2009-02-27 17:09:32Z bvonhaden $

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


package com.dynamic.charm.web.tag;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.servlet.jsp.JspException;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;
import org.springframework.web.util.TagUtils;

import com.dynamic.charm.exception.CharmException;
import com.dynamic.charm.web.tag.support.EvalTool;
import com.dynamic.charm.web.tag.support.ParameterAwareTag;


/**
 * @jsp.tag name="invokeService" body-content="JSP"
 *
 * @author nwest
 */
public class InvokeServiceTag extends ParameterAwareTag
{
    private static final Logger logger = Logger.getLogger(InvokeServiceTag.class);

    static
    {
        TagDefaults.getInstance().registerDefault(InvokeServiceTag.class, "scope", TagUtils.SCOPE_PAGE);
    }

    private String serviceName;
    private String methodName;
    private String var;
    private String scope;

    protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        serviceName = evalTool.evaluateAsString("serviceName", serviceName);
        methodName = evalTool.evaluateAsString("methodName", methodName);
        var = evalTool.evaluateAsString("var", var);
        scope = evalTool.evaluateAsString("scope", scope);
    }

    /*
     * (non-Javadoc)
     *
     * @see org.springframework.web.servlet.tags.RequestContextAwareTag#doStartTagInternal()
     */
    protected int doStartTagInternal() throws Exception
    {
        logger.debug("InvokeServiceTag.doStartTagInternal()");
        TagDefaults.getInstance().setAllDefaults(this);
        return super.doStartTagInternal();
    }

    public int doEndTag() throws JspException
    {
        try
        {
            logger.debug("InvokeServiceTag.doEndTag()");

            Object service = getApplicationContext().getBean(serviceName);

            //grab all the parameters
            Object[] values = paramsToValueArray();

            //get the method by specified name, and see what parameters it uses
            Method method = findMethod(service);
            Class[] paramTypes = method.getParameterTypes();

            //stick all values in to proper class wrappers
            Object[] paramValues = paramsToClassArray(paramTypes, values);

            //ensure that nothing is null, that will cause MethodUtils to blow up
            for (int i = 0; i < paramValues.length; i++)
            {
                if (paramValues[i] == null)
                {
                    throw new CharmException("Null parameters not allowed, no value found for " +
                        paramsToNameArray()[i]);
                }
            }

            Object result = MethodUtils.invokeExactMethod(service, methodName, paramValues,
                    paramTypes);

            if (StringUtils.hasText(var))
            {
                setObjectInScope(var, result, scope);
            }
            else if (result != null)
            {
                write(result.toString());
            }
        }
        catch (NoSuchMethodException e)
        {
            throw new CharmException("NoSuchMethodException accessing method " + methodName + " in service " + serviceName, e);
        }
        catch (InvocationTargetException e)
        {
            throw new CharmException("Exception within execution of method " + methodName + " in service " + serviceName, e.getTargetException());
        }
        catch (Exception e)
        {
            throw new CharmException("Exception in InvokeServiceTag accessing method " + methodName + " in service " + serviceName, e);
        }

        return EVAL_PAGE;
    }

    private Method findMethod(Object serviceInstance) throws NoSuchMethodException
    {
        Method method = null;
        Method[] methods = serviceInstance.getClass().getMethods();

        int numParams = getNumberParameters();
        for (int i = 0; i < methods.length; i++)
        {
            if (methods[i].getName().equals(methodName) && (methods[i].getParameterTypes().length == numParams))
            {
                method = methods[i];
                break;
            }
        }

        if (method == null)
        {
            throw new NoSuchMethodException();
        }

        return method;
    }

    private Object[] paramsToClassArray(Class[] types, Object[] values)
    {
        return com.dynamic.charm.reflect.ConvertUtils.convert(values, types);
    }

    /**
     * Getter for property serviceName.
     *
     * @return Value of property getServiceName.
     * @jsp.attribute required="true" rtexprvalue="true" description="The service name to be used when running methodName."
     */
    public String getServiceName()
    {
        return serviceName;
    }

    public void setServiceName(String serviceName)
    {
        this.serviceName = serviceName;
    }

    /**
     * Getter for property methodName.
     *
     * @return Value of property getMethodName.
     * @jsp.attribute required="true" rtexprvalue="true" description="The method name to be called when invoking serviceName."
     */
    public String getMethodName()
    {
        return methodName;
    }

    public void setMethodName(String methodName)
    {
        this.methodName = methodName;
    }

    /**
     * Getter for property scope.
     *
     * @return Value of property getScope.
     * @jsp.attribute required="false" rtexprvalue="true" description="The scope
     *                to be used when setting the variable value. Allowed values
     *                are page, request, session, and application. Defaults to page"
     */
    public String getScope()
    {
        return scope;
    }

    public void setScope(String scope)
    {
        this.scope = scope;
    }

    /**
     * Getter for property var.
     *
     * @return Value of property getVar.
     * @jsp.attribute required="false" rtexprvalue="true" description="The name of the variable that will be set with the result of the service invocation."
     */
    public String getVar()
    {
        return var;
    }

    public void setVar(String var)
    {
        this.var = var;
    }
}
