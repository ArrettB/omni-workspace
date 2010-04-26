/*
 *               ApexIT, Inc.
 *
 * This software can only be used with the expressed written
 * consent of ApexIT, Inc. All rights reserved.
 *
 * Copyright 2009 ApexIT, Inc.
 * $Id: Codetable2Util.java 1665 2009-08-12 15:49:40Z bvonhaden $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL APEXIT, INC
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

package ims.helpers;

import java.util.Map;

import dynamic.intraframe.engine.InvocationContext;

/**
 * Helper methods for working with codetable2 stored appglobals.
 * 
 * @version $Id: Codetable2Util.java 1665 2009-08-12 15:49:40Z bvonhaden $
 */
public class Codetable2Util
{

	public static String getId(String key, String code, InvocationContext ic)
	{
		String id = null;
		
		Map tableMap = (Map)ic.getAppGlobalDatum(key);
		if (tableMap != null)
		{
			id = (String)tableMap.get(code);
		}
		
		return id;
	}

	
	public static Integer getIntId(String key, String code, InvocationContext ic)
	{
		Integer result = null;
		
		String id = getId(key, code, ic);
		
		if (id != null)
		{
			result = Integer.parseInt(id);
		}
		
		return result;
	}
	
}
