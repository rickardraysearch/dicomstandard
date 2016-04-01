<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	xmlns="http://www.pixelmed.com/namespaces/contextgroups"
	exclude-result-prefixes="d"
  	version="2.0">
	
	<xsl:strip-space elements="*" />
	
	<xsl:output method="text"/>
	
	<xsl:variable name='newline'><xsl:text>
</xsl:text></xsl:variable>
	
	<xsl:template match="d:book">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- match only Annex J table -->
	<xsl:template match="d:table[@label[starts-with(.,'J-')] and not(@label[contains(.,'&lt;')])]">
		<xsl:message>Processing <xsl:value-of select="@label"/></xsl:message>
		<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Retired Code Value'
			and d:thead/d:tr/d:th[2] = 'Code Meaning'
			and d:thead/d:tr/d:th[3] = 'Replacement Code'">
			<xsl:message>Matching table pattern retired and replacement SRT code <xsl:value-of select="@label"/></xsl:message>
			<xsl:for-each select="d:tbody/d:tr">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="normalize-space(d:td[1])"/>
						<xsl:text>,</xsl:text>
						<xsl:text>SRT</xsl:text>
						<xsl:text>,"</xsl:text>
						<xsl:value-of select="normalize-space(d:td[2])"/>
						<xsl:text>")</xsl:text>
						<xsl:value-of select="$newline"/>

						<xsl:text>(</xsl:text>
						<xsl:value-of select="normalize-space(d:td[3])"/>
						<xsl:text>,</xsl:text>
						<xsl:text>SRT</xsl:text>
						<xsl:text>,"</xsl:text>
						<xsl:value-of select="normalize-space(d:td[2])"/>
						<xsl:text>")</xsl:text>
						<xsl:value-of select="$newline"/>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>No matching table pattern for <xsl:value-of select="@label"/></xsl:message>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="node()|@*">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>
