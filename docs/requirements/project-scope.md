# Project Scope

## Confirmed identity

- Company and group name: Cloudrest Wines
- Team: Mia, Zora, Rianna and 1
- Selected perspective: Human Resources, Workforce Planning and Wellbeing
- Sustainability initiative: Sustainable Workforce Safety, Training and Wellbeing Monitoring

## Objective

Design and implement a normalised MySQL 8.x OLTP database that replaces fragmented Word and Excel records. The system covers the complete winery base case and extends it with workforce profiles, training and certification, shifts and labour allocation, safety incidents, corrective actions, wellbeing check-ins and management reporting.

## Proposed sustainability measures

1. Annual safety and sustainability training completion rate by operational area.
2. All recorded workplace safety incidents per 1,000 labour hours by operational area and period.
3. Supporting measures: reportable-incident flag, lost hours, overdue corrective actions, overtime exposure, expiring qualifications and pre/post-training incident trends.

The incident-rate KPI intentionally uses all safety events recorded in `incident`, including near misses, so the numerator matches Query 2. `reportableFlag` remains available for separate statutory/reportability analysis and is not silently substituted for the selected management KPI.

## In scope

- Personnel, roles, employment status, supervisor and contact histories
- Picking packs and seasonal re-employment ratings
- Vineyards, plantings, grape varieties and harvests
- Wines, compositions, medals, products and price history
- Bottle types, suppliers, purchase orders and split receipts
- Individual and business customers, contacts, orders, shipments and refunds
- Structured physical/postal addresses and relevant address history
- HR training, qualifications, shifts, incidents, corrective actions and wellbeing workflows
- Data quality, test data, database-level rules and decision-support reporting

## Out of scope

- Payroll
- Detailed payment instruments and accounting ledger
- Delivery-cost accounting
- Cork, label, barrel and packing-box inventory
- Real personal or health information in development/test data

## Inputs still required

- Official A2 spreadsheet
- Week 11 assigned business scenario
- Blackboard/RiPPlE submission links and any later clarifications
- Genuine member contribution dates and peer feedback
