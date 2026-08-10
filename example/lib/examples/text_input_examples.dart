import 'package:astryx_ui/astryx_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// #example text_input_demo -> TextInputDemoExample
class TextInputDemoExample extends StatelessWidget {
  const TextInputDemoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxTextInput(
        label: 'Workspace name',
        placeholder: 'Acme Internal Tools',
        description: 'Shown to everyone you invite.',
      ),
    );
  }
}
// #end

// #example text_input_sizes -> TextInputSizesExample
class TextInputSizesExample extends StatelessWidget {
  const TextInputSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          for (final size in AstryxInputSize.values)
            AstryxTextInput(
              label: size.name,
              size: size,
              placeholder: 'Placeholder text',
            ),
        ],
      ),
    );
  }
}
// #end

// #example text_input_validation -> TextInputValidationExample
class TextInputValidationExample extends StatefulWidget {
  const TextInputValidationExample({super.key});

  @override
  State<TextInputValidationExample> createState() =>
      _TextInputValidationExampleState();
}

class _TextInputValidationExampleState
    extends State<TextInputValidationExample> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  /// Validate on change here so the example reacts as you type. In a real form,
  /// validating on blur or on submit is usually kinder.
  AstryxFieldStatus? get _status {
    final value = _email.text.trim();
    if (value.isEmpty) return null;
    return value.contains('@')
        ? const AstryxFieldStatus.success('That looks right')
        : const AstryxFieldStatus.error('Enter a valid email address');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Email',
            controller: _email,
            required: true,
            placeholder: 'you@example.com',
            status: _status,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const AstryxTextInput(
            label: 'Subdomain',
            optional: true,
            status: AstryxFieldStatus.warning('This name is nearly taken'),
          ),
        ],
      ),
    );
  }
}
// #end

// #example text_input_affordances -> TextInputAffordancesExample
class TextInputAffordancesExample extends StatefulWidget {
  const TextInputAffordancesExample({super.key});

  @override
  State<TextInputAffordancesExample> createState() =>
      _TextInputAffordancesExampleState();
}

class _TextInputAffordancesExampleState
    extends State<TextInputAffordancesExample> {
  final TextEditingController _search = TextEditingController(text: 'invoice');

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Search',
            labelHidden: true,
            controller: _search,
            showClear: true,
            placeholder: 'Search invoices',
            leading: const AstryxIcon(
              AstryxIconName.search,
              size: AstryxIconSize.sm,
              color: AstryxIconColor.secondary,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const AstryxTextInput(
            label: 'Password',
            obscureText: true,
            autofillHints: <String>[AutofillHints.password],
          ),
          const AstryxTextInput(
            label: 'Seats',
            trailing: AstryxText(
              'of 24',
              type: AstryxTextType.supporting,
              color: AstryxTextColor.secondary,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
// #end

// #example text_input_formatters -> TextInputFormattersExample
class TextInputFormattersExample extends StatelessWidget {
  const TextInputFormattersExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AstryxTextInput(
        label: 'Invite code',
        placeholder: 'ABCD-1234',
        maxLength: 9,
        description: 'Letters are upper-cased as you type.',
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
          TextInputFormatter.withFunction(
            (oldValue, newValue) =>
                newValue.copyWith(text: newValue.text.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
// #end

// #example text_input_states -> TextInputStatesExample
class TextInputStatesExample extends StatelessWidget {
  const TextInputStatesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320,
      child: AstryxVStack(
        gap: AstryxSpacingToken.spacing3,
        align: AstryxStackAlign.stretch,
        children: <Widget>[
          AstryxTextInput(
            label: 'Read-only',
            readOnly: true,
            placeholder: 'acct_0192',
            description: 'The value is meaningful, just not yours to change.',
          ),
          AstryxTextInput(
            label: 'Disabled',
            enabled: false,
            placeholder: 'Managed by your admin',
          ),
        ],
      ),
    );
  }
}
// #end

// #example text_input_multiline -> TextInputMultilineExample
class TextInputMultilineExample extends StatelessWidget {
  const TextInputMultilineExample({super.key});

  @override
  Widget build(BuildContext context) {
    // `AstryxTextInput.multiline` is the same control, grown vertically.
    // `AstryxTextArea` is the friendlier name for the same thing.
    return const SizedBox(
      width: 380,
      child: AstryxTextInput.multiline(
        label: 'What happened?',
        placeholder: 'Steps to reproduce…',
        minLines: 2,
        maxLines: 5,
      ),
    );
  }
}
// #end
