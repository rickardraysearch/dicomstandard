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
	
	<!-- do not want to match Section 7 explanatory tables -->
	<xsl:template match="d:table[@label[starts-with(.,'CID ')] and not(@label[contains(.,'&lt;')])]">
		<xsl:message>Processing <xsl:value-of select="@label"/></xsl:message>
		<xsl:choose>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Code Value'
			and d:thead/d:tr/d:th[3] = 'Code Meaning'
			and d:thead/d:tr/d:th[4] = 'SNOMED-CT Concept ID'
			and d:thead/d:tr/d:th[5] = 'UMLS Concept Unique ID'">
			<!--<xsl:message>Matching table pattern no version but with SCT and UMLS for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[2])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[2])"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="normalize-space(d:td[1])"/>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
						
						<xsl:if test="string-length(normalize-space(d:td[4])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[4])"/>
							<xsl:text>,</xsl:text>
							<xsl:text>SCT</xsl:text>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
						
						<xsl:if test="string-length(normalize-space(d:td[5])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[5])"/>
							<xsl:text>,</xsl:text>
							<xsl:text>UMLS</xsl:text>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
					
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Coding Scheme Version'
			and d:thead/d:tr/d:th[3] = 'Code Value'
			and d:thead/d:tr/d:th[4] = 'Code Meaning'
			and d:thead/d:tr/d:th[5] = 'SNOMED-CT Concept ID'
			and d:thead/d:tr/d:th[6] = 'UMLS Concept Unique ID'">
			<!--<xsl:message>Matching table pattern with version and SCT and UMLS for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 3 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[3])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="normalize-space(d:td[1])"/>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[4])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
						
						<xsl:if test="string-length(normalize-space(d:td[5])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[5])"/>
							<xsl:text>,</xsl:text>
							<xsl:text>SCT</xsl:text>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[4])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
						
						<xsl:if test="string-length(normalize-space(d:td[6])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[6])"/>
							<xsl:text>,</xsl:text>
							<xsl:text>UMLS</xsl:text>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[4])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
					
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Code Value'
			and d:thead/d:tr/d:th[3] = 'Code Meaning'
			and d:thead/d:tr/d:th[5] = 'SNOMED-CT Concept ID'">
			<!--<xsl:message>Matching table pattern no version but with one extra column then SCT but no UMLS for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[2])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[2])"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="normalize-space(d:td[1])"/>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
						
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
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Code Value'
			and d:thead/d:tr/d:th[3] = 'Code Meaning'
			and d:thead/d:tr/d:th[7] = 'SNOMED-CT Concept ID'">
			<!--<xsl:message>Matching table pattern no version but with three extra columns then SCT but no UMLS for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[2])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[2])"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="normalize-space(d:td[1])"/>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
						
						<xsl:if test="string-length(normalize-space(d:td[7])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[7])"/>
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
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Code Value'
			and d:thead/d:tr/d:th[3] = 'Code Meaning'">
			<!--<xsl:message>Matching table pattern no version no SCT and UMLS for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 2 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[2])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[2])"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="normalize-space(d:td[1])"/>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="normalize-space(d:td[1]) = 'SRT'">
					<xsl:message>SRT code <xsl:value-of select="normalize-space(d:td[2])"/> in table without SCT and UMLS columns</xsl:message>
				</xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="d:thead/d:tr/d:th[1] = 'Coding Scheme Designator'
			and d:thead/d:tr/d:th[2] = 'Coding Scheme Version'
			and d:thead/d:tr/d:th[3] = 'Code Value'
			and d:thead/d:tr/d:th[4] = 'Code Meaning'">
			<!--<xsl:message>Matching table pattern with version but no SCT and UMLS for <xsl:value-of select="@label"/></xsl:message>-->
			<xsl:for-each select="d:tbody/d:tr">
				<xsl:choose>
					<xsl:when test="count(d:td) &gt; 3 and not(starts-with(d:td[1],'Include'))">
						<xsl:if test="string-length(normalize-space(d:td[3])) &gt; 0">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="normalize-space(d:td[3])"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="normalize-space(d:td[1])"/>
							<xsl:text>,"</xsl:text>
							<xsl:value-of select="normalize-space(d:td[4])"/>
							<xsl:text>")</xsl:text>
							<xsl:value-of select="$newline"/>
						</xsl:if>
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
