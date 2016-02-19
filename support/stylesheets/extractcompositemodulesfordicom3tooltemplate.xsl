<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:docbook="http://docbook.org/ns/docbook"
	xmlns="http://docbook.org/ns/docbook"
  	version="1.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:variable name="quote">"</xsl:variable>

<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:template name="titleCaseWord">
	<xsl:param name="s"/>

	<xsl:value-of select="translate(substring($s,1,1),$lowercase,$uppercase)"/>
	<xsl:value-of select="substring($s,2,string-length($s)-1)"/>
</xsl:template>

<xsl:template name="titleCaseRemovingSpaces">
	<xsl:param name="s"/>

	<xsl:variable name="rest"><xsl:value-of select="substring-after($s,' ')"/></xsl:variable>
	<xsl:choose>
        <xsl:when test="string-length($rest) > 0">
			<xsl:call-template name="titleCaseWord">
                <xsl:with-param name="s" select="substring-before($s,' ')"/>
            </xsl:call-template>
			<xsl:call-template name="titleCaseRemovingSpaces">
                <xsl:with-param name="s" select="$rest"/>
            </xsl:call-template>
		</xsl:when>
        <xsl:otherwise>
			<xsl:call-template name="titleCaseWord">
                <xsl:with-param name="s" select="$s"/>
            </xsl:call-template>
        </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="processAttributeRow">

		<!-- do not try to canonicalize name to keyword (e.g., remove apostrophes) or look it up (perhaps by tag) yet, except to remove spaces :( -->
		<!-- leave nesting level in name, since not tring to detect sequence start and and yet :( -->
		<xsl:variable name="attribute"><xsl:value-of select="translate(normalize-space(docbook:td[1]/docbook:para),' ','')"/></xsl:variable>
		<!-- ignore tag -->
		<xsl:variable name="type"><xsl:value-of select="translate(normalize-space(docbook:td[3]/docbook:para),' ','')"/></xsl:variable>
		<!-- ignore description -->

		<xsl:text>&#x9;</xsl:text>
		<xsl:choose>
			<xsl:when test="contains($attribute,'Sequence')">
				<xsl:text>Sequence=</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Name=</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$attribute"/>
		<xsl:value-of select="$quote"/>

		<xsl:text>&#x9;</xsl:text>
		<xsl:text>Type=</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$type"/>
		<xsl:value-of select="$quote"/>

		<xsl:if test="contains($attribute,'Sequence')">
		<!-- do not try to extract VM from description for sequences; just put in as 1 as default -->
			<xsl:text>&#x9;</xsl:text>
			<xsl:text>VM=</xsl:text>
			<xsl:value-of select="$quote"/>
			<xsl:text>1</xsl:text>
			<xsl:value-of select="$quote"/>
		</xsl:if>
		
		<xsl:value-of select="$newline"/>

		<xsl:if test="contains($attribute,'Sequence')">
			<xsl:text>&#x9;</xsl:text>
			<xsl:text>SequenceEnd</xsl:text>
		<xsl:value-of select="$newline"/>
		</xsl:if>

</xsl:template>

<xsl:template name="processMacroInclusion">

		<!-- do not try to look up actual name of macro from table reference yet :( -->
		<xsl:variable name="macro"><xsl:value-of select="docbook:td[1]//docbook:xref/@linkend"/></xsl:variable>
		<!-- ignore description -->

		<xsl:text>&#x9;</xsl:text>
		<xsl:text>InvokeMacro=</xsl:text>
		<xsl:value-of select="$quote"/>
		<xsl:value-of select="$macro"/>
		<xsl:value-of select="$quote"/>
		
		<xsl:value-of select="$newline"/>

</xsl:template>

<xsl:template match="docbook:table">
	<xsl:choose>
		<xsl:when test="contains(docbook:caption,'Module Attributes')
					and docbook:thead/docbook:tr/docbook:th[1]/docbook:para = 'Attribute Name'
					and docbook:thead/docbook:tr/docbook:th[2]/docbook:para = 'Tag'
					and docbook:thead/docbook:tr/docbook:th[3]/docbook:para = 'Type'
					and docbook:thead/docbook:tr/docbook:th[4]/docbook:para = 'Attribute Description'">
			<xsl:variable name="module"><xsl:value-of select="substring-before(translate(normalize-space(docbook:caption),' -',''),'ModuleAttributes')"/></xsl:variable>
			<xsl:text>Module=</xsl:text>
			<xsl:value-of select="$quote"/>
			<xsl:value-of select="$module"/>
			<xsl:value-of select="$quote"/>
			<xsl:value-of select="$newline"/>
			
			<!-- <xsl:apply-templates/> -->
			
			<xsl:for-each select="docbook:tbody/docbook:tr">
				<xsl:choose>
					<xsl:when test="count(docbook:td) = 4">
						<xsl:call-template name="processAttributeRow"/>
					</xsl:when>
					<xsl:when test="count(docbook:td) &lt; 4 and contains(docbook:td[1],'Include')">
						<xsl:call-template name="processMacroInclusion"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			
			<xsl:text>ModuleEnd</xsl:text>
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="$newline"/>
		</xsl:when>
		<xsl:when test="contains(docbook:caption,'Macro Attributes')
					and docbook:thead/docbook:tr/docbook:th[1]/docbook:para = 'Attribute Name'
					and docbook:thead/docbook:tr/docbook:th[2]/docbook:para = 'Tag'
					and docbook:thead/docbook:tr/docbook:th[3]/docbook:para = 'Type'
					and docbook:thead/docbook:tr/docbook:th[4]/docbook:para = 'Attribute Description'">
			<xsl:variable name="macro"><xsl:value-of select="substring-before(translate(normalize-space(docbook:caption),' -',''),'Attributes')"/></xsl:variable> <!-- leave macro in name, unlikle module -->
			<xsl:text>DefineMacro=</xsl:text>
			<xsl:value-of select="$quote"/>
			<xsl:value-of select="$macro"/>
			<xsl:value-of select="$quote"/>
			<!-- do not attempt to guess InformationEntity=""; leave it empty :( -->
			<xsl:value-of select="$newline"/>
			
			<!-- <xsl:apply-templates/> -->
			
			<xsl:for-each select="docbook:tbody/docbook:tr">
				<xsl:choose>
					<xsl:when test="count(docbook:td) = 4">
						<xsl:call-template name="processAttributeRow"/>
					</xsl:when>
					<xsl:when test="count(docbook:td) &lt; 4 and contains(docbook:td[1],'Include')">
						<xsl:call-template name="processMacroInclusion"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			
			<xsl:text>MacroEnd</xsl:text>
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="$newline"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
	<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
