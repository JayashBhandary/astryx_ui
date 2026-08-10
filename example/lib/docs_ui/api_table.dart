import 'package:astryx_ui/astryx_ui.dart';
import 'package:example/docs/model.dart';
import 'package:example/docs_ui/inline_markup.dart';
import 'package:flutter/widgets.dart';

/// A property reference table for one class.
///
/// Built from `AstryxTable`, which is both the right widget and a useful check:
/// the table has to survive being handed prose, code and badges in its cells.
class DocsApiTable extends StatelessWidget {
  const DocsApiTable(this.api, {super.key});

  final DocApi api;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        AstryxHeading(api.title, level: 4),
        if (api.description != null)
          DocsInlineText(
            api.description!,
            color: AstryxTextColor.secondary,
          ),
        AstryxTable<DocProp>(
          label: '${api.title} properties',
          rows: api.props,
          keyOf: (row) => row.name,
          minWidth: 560,
          columns: <AstryxTableColumn<DocProp>>[
            AstryxTableColumn<DocProp>(
              id: 'name',
              header: 'Property',
              width: const AstryxTableColumnWidth.intrinsic(
                min: 120,
                max: 200,
              ),
              cellBuilder: (context, row) => AstryxHStack(
                gap: AstryxSpacingToken.spacing1,
                wrap: true,
                children: <Widget>[
                  AstryxText(row.name, type: AstryxTextType.code),
                  if (row.required)
                    const AstryxBadge(
                      'required',
                      variant: AstryxBadgeVariant.info,
                    ),
                ],
              ),
            ),
            AstryxTableColumn<DocProp>(
              id: 'type',
              header: 'Type',
              width: const AstryxTableColumnWidth.intrinsic(
                min: 110,
                max: 220,
              ),
              cellBuilder: (context, row) => AstryxText(
                row.type,
                type: AstryxTextType.code,
                color: AstryxTextColor.secondary,
              ),
            ),
            AstryxTableColumn<DocProp>(
              id: 'default',
              header: 'Default',
              width: const AstryxTableColumnWidth.intrinsic(min: 80, max: 200),
              cellBuilder: (context, row) => AstryxText(
                row.defaultValue ?? '—',
                type: row.defaultValue == null
                    ? AstryxTextType.body
                    : AstryxTextType.code,
                color: AstryxTextColor.secondary,
              ),
            ),
            AstryxTableColumn<DocProp>(
              id: 'description',
              header: 'Description',
              width: const AstryxTableColumnWidth.flex(2),
              cellBuilder: (context, row) => DocsInlineText(
                row.description,
                type: AstryxTextType.supporting,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A free-form table — enum values, tokens, keyboard shortcuts.
class DocsDataTable extends StatelessWidget {
  const DocsDataTable(this.table, {super.key});

  final DocTable table;

  @override
  Widget build(BuildContext context) {
    return AstryxVStack(
      gap: AstryxSpacingToken.spacing2,
      align: AstryxStackAlign.stretch,
      children: <Widget>[
        if (table.title != null)
          DocsInlineText(table.title!, type: AstryxTextType.label),
        AstryxTable<List<String>>(
          label: table.title ?? 'Reference',
          rows: table.rows,
          keyOf: (row) => row.first,
          minWidth: 480,
          columns: <AstryxTableColumn<List<String>>>[
            for (var i = 0; i < table.headers.length; i++)
              AstryxTableColumn<List<String>>(
                id: '${table.headers[i]}-$i',
                header: table.headers[i],
                width: i == table.headers.length - 1
                    ? const AstryxTableColumnWidth.flex(2)
                    : const AstryxTableColumnWidth.intrinsic(
                        min: 100,
                        max: 220,
                      ),
                cellBuilder: (context, row) => DocsInlineText(
                  i < row.length ? row[i] : '',
                  type: AstryxTextType.supporting,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
