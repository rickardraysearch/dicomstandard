<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="text"/>
  
 <xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>

 <xsl:template match="text()">
  <!--<xsl:analyze-string select="normalize-space(.) " regex="[(][^()]*,[^()]*,[^)]*[)]">-->
  <xsl:analyze-string select="normalize-space(.) " regex='[(]\s*[^,()][^,()]*\s*,\s*[A-Z0-9_][A-Z0-9_]*\s*,\s*"[^)][^)]*"\s*[)]'>
   <xsl:matching-substring>
     <xsl:value-of select="."/>
	 <xsl:value-of select="$newline"/>
   </xsl:matching-substring>
  </xsl:analyze-string>
 </xsl:template>

</xsl:stylesheet>
