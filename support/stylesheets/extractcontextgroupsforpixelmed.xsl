<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:d="http://docbook.org/ns/docbook"
	xmlns="http://www.pixelmed.com/namespaces/contextgroups"
	exclude-result-prefixes="d"
  	version="1.0">

<xsl:strip-space elements="*" />

<xsl:output omit-xml-declaration="no" method="xml" indent="yes" encoding="UTF-8" />

<xsl:template match="d:book">
	<definecontextgroups
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns="http://www.pixelmed.com/namespaces/contextgroups"
			xsi:schemaLocation="http://www.pixelmed.com/namespaces/contextgroups http://www.pixelmed.com/schemas/contextgroups.xsd">
		<xsl:apply-templates match=""/>
	</definecontextgroups>
</xsl:template>

<!-- do not want to match Section 7 explanatory tables -->
<xsl:template match="d:table[@label[starts-with(.,'CID ')] and not(@label[contains(.,'&lt;')])]">
	<xsl:variable name="extensible">
		<xsl:choose>
		<xsl:when test="starts-with(../d:variablelist/d:varlistentry[d:term='Type:']/d:listitem,'Non')">F</xsl:when>
		<xsl:otherwise>T</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<definecontextgroup
			cid="{substring(@label,5)}"
			name="{translate(d:caption,' -','')}"
			extensible="{$extensible}"
			version="{../d:variablelist/d:varlistentry[d:term='Version:']/d:listitem}"
			uid="{../d:variablelist/d:varlistentry[d:term='UID:']/d:listitem}"
		>
		<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
				  and d:thead/d:tr/d:th[2] = 'Code Value'
				  and d:thead/d:tr/d:th[3] = 'Code Meaning'
				  and d:thead/d:tr/d:th[4] = 'SNOMED-CT Concept ID'
				  and d:thead/d:tr/d:th[5] = 'UMLS Concept Unique ID'
				  and d:thead/d:tr/d:th[6] = 'Segmentation Property Type Context Group'">
			<xsl:for-each select="d:tbody/d:tr[string-length(normalize-space(d:td[1])) &gt; 0]">	<!-- ignore empty rows -->
				<xsl:variable name="linkend"><xsl:value-of select="d:td[6]/descendant::d:xref[1]/@linkend"/></xsl:variable>		<!-- Should be d:td[6]/d:para/d:emphasis/d:xref/@linkend} but just in case, go straight to d:xref -->
				<xsl:choose>
				<!-- should be no include rows, only codes plus corresponding category CID-->
				<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
					<contextgroupcode csd="{normalize-space(d:td[1])}" cv="{normalize-space(d:td[2])}" cm="{normalize-space(d:td[3])}" sct="{normalize-space(d:td[4])}" umlscui="{normalize-space(d:td[5])}" propertyTypeCIDForCategory="{normalize-space(substring-after($linkend,'sect_CID_'))}"/>
				</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
				  and d:thead/d:tr/d:th[2] = 'Code Value'
				  and d:thead/d:tr/d:th[3] = 'Code Meaning'
				  and d:thead/d:tr/d:th[4] = 'SNOMED-CT Concept ID'
				  and d:thead/d:tr/d:th[5] = 'UMLS Concept Unique ID'">
			<xsl:for-each select="d:tbody/d:tr[string-length(normalize-space(d:td[1])) &gt; 0]">	<!-- ignore empty rows -->
				<xsl:variable name="linkend"><xsl:value-of select="d:td[1]/descendant::d:xref[1]/@linkend"/></xsl:variable>		<!-- Should be d:td[1]/d:para/d:emphasis/d:xref/@linkend} but just in case, go straight to d:xref -->
				<xsl:choose>
				<xsl:when test="starts-with(d:td[1],'Include') and count($linkend) &gt; 0 and starts-with($linkend,'sect_CID_')">	<!-- linkend is of the form 'sect_CID_4040' -->
					<include cid="{normalize-space(substring-after($linkend,'sect_CID_'))}"/>
				</xsl:when>
				<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
					<contextgroupcode csd="{normalize-space(d:td[1])}" cv="{normalize-space(d:td[2])}" cm="{normalize-space(d:td[3])}" sct="{normalize-space(d:td[4])}" umlscui="{normalize-space(d:td[5])}"/>
				</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
				  and d:thead/d:tr/d:th[2] = 'Code Value'
				  and d:thead/d:tr/d:th[3] = 'Code Meaning'">
			<xsl:for-each select="d:tbody/d:tr[string-length(normalize-space(d:td[1])) &gt; 0]">	<!-- ignore empty rows -->
				<xsl:variable name="linkend"><xsl:value-of select="d:td[1]/descendant::d:xref[1]/@linkend"/></xsl:variable>		<!-- Should be d:td[1]/d:para/d:emphasis/d:xref/@linkend} but just in case, go straight to d:xref -->
				<xsl:choose>
				<xsl:when test="starts-with(d:td[1],'Include') and count($linkend) &gt; 0 and starts-with($linkend,'sect_CID_')">	<!-- linkend is of the form 'sect_CID_4040' -->
					<include cid="{normalize-space(substring-after($linkend,'sect_CID_'))}"/>
				</xsl:when>
				<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
					<contextgroupcode csd="{normalize-space(d:td[1])}" cv="{normalize-space(d:td[2])}" cm="{normalize-space(d:td[3])}"/>
				</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		</xsl:choose>
	</definecontextgroup>
</xsl:template>

<xsl:template match="node()|@*">
		<xsl:apply-templates match=""/>
</xsl:template>

</xsl:stylesheet>
