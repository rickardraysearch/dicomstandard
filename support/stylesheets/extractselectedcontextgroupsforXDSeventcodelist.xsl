<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	exclude-result-prefixes="d"
  	version="1.0">
	
	<!-- no namespace is specified (i.e., there is no <xsl:stylesheet xmlns="..."/> attribute supplied) -->
	
	<xsl:strip-space elements="*" />
	
	<xsl:output omit-xml-declaration="no" method="xml" indent="yes" encoding="UTF-8" />
	
	<xsl:template match="d:book">
		<Codes>
			<CodeType name="eventCodeList" classScheme="urn:uuid:2c6b8cb7-8b2a-4051-b291-b1ae6a575ef4">
				<xsl:apply-templates/>
			</CodeType>
		</Codes>
	</xsl:template>
	
	<!-- match the selected tables the same way, whether they be the top level context group, or one that is known to be included (not worth the effort of automatically detecting the include directive) -->
	<xsl:template match="d:table[@label = 'CID 4'
							  or @label = 'CID 4030'
							  or @label = 'CID 4031'
							  or @label = 'CID 4040'
							  or @label = 'CID 4042'
							  or @label = 'CID 3010'
							  or @label = 'CID 29']">
		<xsl:message>Processing <xsl:value-of select="@label"/></xsl:message>
		<xsl:comment><xsl:value-of select="@label"/></xsl:comment>
		<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Code Value'
			and d:thead/d:tr/d:th[3] = 'Code Meaning'">
			<!--<xsl:message>Matching table pattern no version for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[2])) &gt; 0">
							<Code codingScheme="{normalize-space(d:td[1])}" code="{normalize-space(d:td[2])}" display="{normalize-space(d:td[3])}"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Coding Scheme Version'
			and d:thead/d:tr/d:th[3] = 'Code Value'
			and d:thead/d:tr/d:th[4] = 'Code Meaning'">
			<!--<xsl:message>Matching table pattern with version for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 3 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[3])) &gt; 0">
							<!-- output format does not handle version, so just ignore ? if this ever happens for any of the selected CIDs anyway ? -->
							<Code codingScheme="{normalize-space(d:td[1])}" code="{normalize-space(d:td[3])}" display="{normalize-space(d:td[4])}"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>No matching table pattern for <xsl:value-of select="@label"/></xsl:message>
		</xsl:otherwise>
		</xsl:choose>
		<xsl:comment>End of <xsl:value-of select="@label"/></xsl:comment>
	</xsl:template>
	
	<xsl:template match="node()|@*">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>
