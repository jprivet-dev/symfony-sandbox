<?php

namespace App\Dto;

use Symfony\Component\Uid\Uuid;

readonly class TagDto
{
    public function __construct(
        public Uuid $id,
        public string $name,
        public int $postsCount,
    ) {
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getPostsCount(): int
    {
        return $this->postsCount;
    }
}
