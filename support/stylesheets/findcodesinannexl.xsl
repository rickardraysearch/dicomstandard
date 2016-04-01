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
	
	<!-- match only Annex L tables -->
	<xsl:template match="d:table[@label[starts-with(.,'L-')] and not(@label[contains(.,'&lt;')])]">
		<xsl:message>Processing <xsl:value-of select="@label"/></xsl:message>
		<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'SNOMED Code Value'
			and d:thead/d:tr/d:th[2] = 'Code Meaning'
			and d:thead/d:tr/d:th[4] = 'SNOMED-CT Concept ID'">
			<xsl:message>Matching table pattern just SRT and SCT for <xsl:value-of select="@label"/></xsl:message>
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="normalize-space(d:td[1])"/>
						<xsl:text>,</xsl:text>
						<xsl:text>SRT</xsl:text>
						<xsl:text>,"</xsl:text>
						<xsl:value-of select="normalize-space(d:td[2])"/>
						<xsl:text>")</xsl:text>
						<xsl:value-of select="$newline"/>

						<xsl:text>(</xsl:text>
						<xsl:value-of select="normalize-space(d:td[4])"/>
						<xsl:text>,</xsl:text>
						<xsl:text>SCT</xsl:text>
						<xsl:text>,"</xsl:text>
						<xsl:value-of select="normalize-space(d:td[2])"/>
						<xsl:text>")</xsl:text>
						<xsl:value-of select="$newline"/>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="normalize-space(d:td[1]) = 'SRT'">
					<xsl:message>SRT code <xsl:value-of select="normalize-space(d:td[2])"/> in table without SCT and UMLS columns</xsl:message>
				</xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'SNOMED Code Value'
			and d:thead/d:tr/d:th[2] = 'Code Meaning'">
			<xsl:message>Matching table pattern just SRT and SCT <xsl:value-of select="@label"/></xsl:message>
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="normalize-space(d:td[1])"/>
						<xsl:text>,</xsl:text>
						<xsl:text>SRT</xsl:text>
						<xsl:text>,"</xsl:text>
						<xsl:value-of select="normalize-space(d:td[2])"/>
						<xsl:text>")</xsl:text>
						<xsl:value-of select="$newline"/>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="normalize-space(d:td[1]) = 'SRT'">
					<xsl:message>SRT code <xsl:value-of select="normalize-space(d:td[2])"/> in table without SCT and UMLS columns</xsl:message>
				</xsl:if>
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
