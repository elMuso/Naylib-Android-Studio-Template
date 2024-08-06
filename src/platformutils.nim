proc getResourcePath*(path: string): string =
    when defined(android):
        return path
    return "assets/" & path
