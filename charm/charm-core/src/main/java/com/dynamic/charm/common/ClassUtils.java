/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: ClassUtils.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.common;

import org.apache.log4j.Logger;

import com.dynamic.charm.exception.CharmException;


public class ClassUtils
{
    private final static Logger logger = Logger.getLogger(ClassUtils.class);

    public static Object instantiate(String classname)
    {
        if (StringUtils.isBlank(classname))
        {
            return null;
        }

        try
        {
            Class clazz = Class.forName(classname);
            return clazz.newInstance();
        }
        catch (ClassNotFoundException e)
        {
            throw new CharmException("ClassNotFoundException when instatiating " + classname, e);
        }
        catch (InstantiationException e)
        {
            throw new CharmException("InstantiationException when instatiating " + classname, e);
        }
        catch (IllegalAccessException e)
        {
            throw new CharmException("IllegalAccessException when instatiating " + classname, e);
        }
    }
}
