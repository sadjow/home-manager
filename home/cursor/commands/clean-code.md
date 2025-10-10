# Clean Code Principles and Techniques

## Fundamental Principles

1. **DRY (Don't Repeat Yourself)** - Avoid code duplication by abstracting common functionality.

2. **KISS (Keep It Simple, Stupid)** - Simplicity should be a key goal in design. Avoid unnecessary complexity.

3. **YAGNI (You Aren't Gonna Need It)** - Don't add functionality until it's necessary.

4. **Principle of Least Surprise** - Code should behave in a way that most users would expect.

5. **Boy Scout Rule** - Leave the code cleaner than you found it.

## Naming Conventions

6. **Intention-Revealing Names** - Names should tell why something exists, what it does, and how it's used.

7. **Pronounceable Names** - Use names that can be spoken in conversation.

8. **Searchable Names** - Avoid single-letter names except for local variables in short methods.

9. **Avoid Encodings** - Don't prefix member variables or include type information in names.

10. **Use Domain Names** - Use terminology from the problem domain.

## Function Design

11. **Small Functions** - Functions should be small and do one thing only.

12. **Descriptive Function Names** - Names should say what they do and be consistent in level of abstraction.

13. **Function Arguments** - Minimize the number of arguments (ideally 0-2).

14. **No Side Effects** - Functions should not have unexpected side effects.

15. **Command Query Separation** - Functions should either do something or answer something, not both.

## Code Organization

16. **Single Responsibility Principle** - A class or module should have only one reason to change.

17. **Open/Closed Principle** - Software entities should be open for extension but closed for modification.

18. **Liskov Substitution Principle** - Subtypes must be substitutable for their base types.

19. **Interface Segregation Principle** - Many client-specific interfaces are better than one general-purpose interface.

20. **Dependency Inversion Principle** - Depend on abstractions, not concretions.

## Error Handling

21. **Use Exceptions Rather Than Return Codes** - Makes code cleaner without error handling logic mixed with normal code.

22. **Provide Context with Exceptions** - Create informative error messages with stack traces.

23. **Define Exception Classes** - Define exception classes in terms of a caller's needs.

24. **Don't Return Null** - Return empty collections or special case objects instead of null.

## Comments and Documentation

25. **Self-Documenting Code** - Write code that explains itself, minimizing the need for comments.
    - Use clear, descriptive variable and method names that explain their purpose
    - Extract complex expressions into well-named methods
    - Structure code to make the flow and intent obvious

26. **Explain Intent, Not Mechanism** - Comments should explain why, not what the code does.
    - Bad: `# Increment counter by 1`
    - Good: `# We need to increment before validation due to legacy system requirements`

27. **Avoid Redundant Comments** - Don't add comments that merely restate what the code already expresses clearly.
    - Redundant: `def invalid_token_failure # Creates a failure result for invalid token`
    - If the method name clearly states its purpose, no comment is needed

28. **Document Only When Necessary** - Use comments in these specific cases:
    - To explain business rules or domain concepts not obvious from code
    - To document why a non-obvious solution was chosen over alternatives
    - To explain workarounds or warn about edge cases
    - For public APIs that will be used by other developers

29. **Use Documentation Tools Judiciously** - For libraries and public APIs, use documentation generators (YARD, RDoc) but:
    - Focus on documenting the "why" and domain concepts
    - Don't document every private method if the code is already clear
    - For complex parameter or return types, documentation can be helpful

30. **Keep Comments Updated** - Outdated comments are worse than no comments at all.
    - Make updating comments part of the code change process
    - Delete comments that are no longer accurate

31. **Code Should Speak For Itself** - If you find yourself writing a lengthy comment, consider:
    - Is the code too complex?
    - Can it be simplified?
    - Can it be broken into smaller, well-named methods?
    - Does it need to be restructured to make the intent clearer?

## Testing

29. **Test-Driven Development (TDD)** - Write tests before code.

30. **Clean Tests** - Tests should be readable and maintainable.

31. **One Assert Per Test** - Each test should validate one concept.

32. **F.I.R.S.T.** - Tests should be Fast, Independent, Repeatable, Self-validating, and Timely.

## Refactoring Techniques

33. **Extract Method** - Extract code fragments into separate methods.

34. **Replace Temp with Query** - Extract expressions assigned to temporary variables into methods.

35. **Replace Conditional with Polymorphism** - Use polymorphic objects instead of complex conditionals.

36. **Decompose Conditional** - Extract methods from condition, then and else parts.

37. **Consolidate Duplicate Conditional Fragments** - Move code that appears in all branches of a conditional.

## Advanced Practices

38. **Law of Demeter** - An object should only communicate with its immediate friends.

39. **Tell, Don't Ask** - Tell objects what to do, don't ask for their state and make decisions for them.

40. **Composition Over Inheritance** - Favor object composition over class inheritance.

41. **Separation of Concerns** - Different areas of functionality should be managed by distinct modules.

42. **Continuous Refactoring** - Refactor continuously rather than having dedicated "refactoring phases."
