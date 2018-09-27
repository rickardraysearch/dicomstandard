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
	
	<tr valign="top">
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_77c111ad-ce6f-4ff9-a5fd-1f2804fe3007">
				<emphasis role="bold">Coding Scheme</emphasis>
			</para>
		</th>
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_16f26bbc-9190-4ed2-b3a0-147207725c5b">
				<emphasis role="bold">Code Value</emphasis>
			</para>
		</th>
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_afc02490-4751-4f51-bf8b-3f09d877f25f">
				<emphasis role="bold">Code Meaning</emphasis>
			</para>
		</th>
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_122bb0a4-46bd-4d89-bd1c-a5a83aefa6f2">
				<emphasis role="bold">Body Part Examined</emphasis>
			</para>
		</th>
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_c826bbd1-ed71-4218-8d6f-5a4b0da4c757">
				<emphasis role="bold">SNOMED-CT Concept ID</emphasis>
			</para>
		</th>
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_5537f494-e5e4-4b4e-bd50-0a11db1eaeaf">
				<emphasis role="bold">FMA Code Value</emphasis>
			</para>
		</th>
		<th align="center" colspan="1" rowspan="1">
			<para xml:id="para_afa2bf85-c238-45c5-b420-9fe0ede4fb09">
				<emphasis role="bold">UMLS Concept UniqueID</emphasis>
			</para>
		</th>
	</tr>
	
	<!-- match only Annex L tables -->
	<xsl:template match="d:table[@label[starts-with(.,'L-')] and not(@label[contains(.,'&lt;')])]">
		<xsl:message>Processing <xsl:value-of select="@label"/></xsl:message>
		<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[2] = 'Code Value'
			and d:thead/d:tr/d:th[3] = 'Code Meaning'
			and d:thead/d:tr/d:th[5] = 'SNOMED-CT Concept ID'">
			<xsl:message>Matching table pattern for SRT Code Value and SCT codes <xsl:value-of select="@label"/></xsl:message>
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 3 and normalize-space(d:td[1]) = 'SRT'">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="normalize-space(d:td[2])"/>
						<xsl:text>,</xsl:text>
						<xsl:text>SRT</xsl:text>
						<xsl:text>,"</xsl:text>
						<xsl:value-of select="normalize-space(d:td[3])"/>
						<xsl:text>")</xsl:text>
						<xsl:value-of select="$newline"/>

						<xsl:if test="string-length(normalize-space(d:td[5])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[5])"/>
							<xsl:text>,</xsl:text>
							<xsl:text>SCT</xsl:text>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'SNOMED Code Value'
			and d:thead/d:tr/d:th[2] = 'Code Meaning'">
			<xsl:message>Matching table pattern for SNOMED Code Value column alone <xsl:value-of select="@label"/></xsl:message>
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2">
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
