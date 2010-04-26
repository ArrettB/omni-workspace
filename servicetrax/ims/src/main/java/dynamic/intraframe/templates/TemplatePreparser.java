package dynamic.intraframe.templates;
import java.util.Vector;

import org.apache.oro.text.regex.MalformedPatternException;
import org.apache.oro.text.regex.Perl5Compiler;
import org.apache.oro.text.regex.Perl5Matcher;
import org.apache.oro.text.regex.Perl5Pattern;
import org.apache.oro.text.regex.Perl5Substitution;
import org.apache.oro.text.regex.Util;

public class TemplatePreparser
{
	Perl5Matcher matcher = new Perl5Matcher();
	Perl5Compiler compiler = new Perl5Compiler();
	private Vector patterns = new Vector();
	private Vector substitutions = new Vector();
	
	public synchronized void destroy()
	{
		if (patterns != null) patterns.removeAllElements();
		patterns = null;
		if (substitutions != null) substitutions.removeAllElements();
		substitutions = null;
		matcher = null;
		compiler = null;
	}

	public synchronized void addSubstitution(String pattern_string, String substitution_string) throws MalformedPatternException
	{
		Perl5Pattern pattern = (Perl5Pattern) compiler.compile(pattern_string);
		patterns.addElement(pattern);
		Perl5Substitution substitution = new Perl5Substitution(substitution_string);
		substitutions.addElement(substitution);
	}

	public synchronized String performSubstitutions(String input)
	{
		String result = input;

		for (int i = 0 ; i < patterns.size() ; i++)
			result = Util.substitute(matcher, (Perl5Pattern)patterns.elementAt(i), (Perl5Substitution)substitutions.elementAt(i), result, Util.SUBSTITUTE_ALL);

		return result;
	}
}